@services.factory('Dashboard', ['DashboardEvent', (DashboardEvent) ->
  class Dashboard
    constructor: ->
      @events = crossfilter([])
      @users = {}
      @devices = {}
      @severity = {user: {}, country: {}}
      @devices = {}
      @deviceSeverity = {}
      @filters = []
      @state = {}

      @initializeDimensions()

    initializeDimensions: =>

      # No dimension dimension
      dimension = @events.dimension (event) -> event._id
      @events.allDimension = dimension
      @events.all = dimension.group()

      # Event type dimension
      dimension = @events.dimension (event) -> event.name
      @events.ruleDimension = dimension
      @events.rule = dimension.group()

      # User dimension
      dimension = @events.dimension (event) -> (event._users && event._users[0]) || "null"
      @events.userDimension = dimension
      @events.user = dimension.group()

      # Country dimension
      dimension = @events.dimension (event) -> 
        ips = _.filter event.ips, (ip) -> !!ip.co
        if ips.length then ips[0].co else "null"
      @events.countryDimension = dimension
      @events.country = dimension.group()

    addEvents: (events) =>
      for event in events
        event.loaded()
        @adjustUserSeverity(event)
      @events.add(events)

    addDevice: (device) =>
      @devices[device.id] = device

    device: (id) =>
      @devices[id]
      
    # user helpers

    addUser: (user) =>
      @users[user.id] = user
      user.severity = @severity.user[user.id]
      user.severityGroup = ->
        DashboardEvent.severityGroup(@severity)

    user: (id) =>
      @users[id]

    adjustCountrySeverity: (event) ->
      severity = event.payload.severity
      for ip in event.ips
        if severity > (@severity.country[ip.co] || 0)
          @severity.country[ip.co] = severity

    adjustUserSeverity: (event) ->
      severity = event.payload.severity
      for user in event._users
        if severity > (@severity.user[user] || 0)
          @severity.user[user] = severity
          user = @user(user)
          user.severity = severity if user

  Dashboard
])