# TODO - Make the customer id lookup a LRU cache
_when = require("when")

class EventProcessor
  constructor: (@redis, @pusher) ->
    @queueName = "api_event_queue"
    @eventsProcessed = 0
    @companies = {}

  start: () =>
    Company.find (err, companies) =>
      for company in companies
        @companyLoaded(company)

      @timerId = setInterval =>
        @checkQueue()
      , 1000, 1000

      @sizeTimerId = setInterval =>
        @redis.llen @queueName, (err, value) =>
          console.log "event queue size: #{value}"
      , 60000, 60000
      @


  stop: () =>
    clearInterval(@timerId)
    clearInterval(@sizeTimerId)

  enqueue: (event) =>
    @redis.lpush @queueName, JSON.stringify(event), (err, reply) =>
      console.log "ERROR: #{err}" if err

  checkQueue: (events=[]) =>
    @redis.lpop @queueName, (err, value) =>
      throw err if err
      if !value
        # process the events
        @eventsProcessed += events.length
        console.log "total events processed(2): #{@eventsProcessed}"
        @processEvents(events)
      else if value
        events.push JSON.parse value
        @checkQueue(events)



  processEvents: (events) =>
    console.log "processing #{events.length} events"

    for json in events
      do (json) =>
        @loadCompany json, (company) =>
          schema = company.object.schemas()
          users = []
          promises = _.map json.event.users, (user) => @ensureUser(schema, company, user).then (user) -> users.push(user)
          usersLoaded = () =>
            @ensureDevice(schema, company, json.event.device).then (device) =>
              e = new schema.Event({
                _users: _.map users, (user) -> user.id
                _device: device.id
                timestamp: json.event.timestamp
                name: json.event.name
                payload: json.event.payload
                ips: @geocode(json.event.payload.ip_addresses)
              })
              e.save (err) =>
                if err
                  console.log "error: #{err}"
                else
                  browserNotifier.enqueue(company.apikey, e)
          _when.all(promises).then(usersLoaded)

  geocode: (ip_addresses) =>
    locations = []
    for ip in ip_addresses
      details = geoip.lookup(ip)
      if details
        locations.push {ip: ip, ll: details.ll, city: details.city, region: details.region, country: details.country}
    locations

  loadCompany: (e, callback, retries=0) =>
    return if retries > 10
    apikey = e.account
    company = @companies[apikey]
    if company
      callback(company)
    else
      Company.findOne {apikey: apikey}, (err, company) =>
        if err
          setTimeout =>
            loadCompany(e, callback, retries+1)
          , 500
        else if company
          callback @companyLoaded(company)

  companyLoaded: (company) =>
    company.schemas()
    h = {id: company.id, apikey: company.apikey, users: {}, devices: {}, object: company}
    @companies[company.apikey] = h
    h

  ensureUser: (schema, company, json) =>
    deferred = _when.defer()
    user = @companies[company.apikey].users[json.identifier] if @companies[company.apikey]
    if user
      deferred.resolve(user)
    else
      success = (user) -> deferred.resolve(user)
      error = (err) -> deferred.reject(err)
      @findOrCreateUser(schema, company, json).then(success, error)
    deferred.promise

  findOrCreateUser: (schema, company, json) ->
    deferred = _when.defer()
    schema.User.findOne {identifier: json.identifier}, (err, user) =>
      if user
        deferred.resolve(user)
      else
        success = (user) -> deferred.resolve(user)
        error = (err) -> deferred.reject(err)
        @createUser(schema, company, json).then(success, error)
    deferred.promise

  createUser: (schema, company, json) ->
    deferred = _when.defer()
    user = new schema.User
      identifier: json.identifier,
      firstName: json.firstName,
      lastName: json.lastName,
      email: json.email,
      pictureUrl: json.pictureUrl
    user.save (err) => 
      if err
        deferred.reject(err)
      else
        deferred.resolve(user)
        @companies[company.apikey].devices[json.identifier] = user
        @pusher.trigger company.apikey, 'user', user
    deferred.promise

  ensureDevice: (schema, company, json) =>
    deferred = _when.defer()
    deferred.resolve(null) unless json
    device = @companies[company.apikey].devices[json.identifier] if @companies[company.apikey]
    if (device)
      deferred.resolve(device)
    else
      success = (device) -> deferred.resolve(device)
      error = (err) -> deferred.reject(err)
      @findOrCreateDevice(schema, company, json).then(success, error)
    deferred.promise

  findOrCreateDevice: (schema, company, json) =>
    deferred = _when.defer()
    schema.Device.findOne {identifier: json.identifier}, (err, device) =>
      if device
        deferred.resolve(device)
      else
        success = (device) -> deferred.resolve(device)
        error = (err) -> deferred.reject(err)
        @createDevice(schema, company, json).then(success, error)
    deferred.promise

  createDevice: (schema, company, json) =>
    deferred = _when.defer()
    device = new schema.Device
      identifier: json.identifier
      ip: json.ip
      hostname: json.hostname
    device.save (err) =>
      if err
        deferred.reject(err)
      else
        @companies[company.apikey].devices[json.identifier] = device
        deferred.resolve(device)
        @pusher.trigger company.apikey, 'device', device
    deferred.promise

module.exports = EventProcessor
