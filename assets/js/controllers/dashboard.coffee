DashboardCtrl = ($scope, $rootScope, $routeParams, Dashboard, DashboardUser, DashboardDevice, DashboardEvent, country) ->
  $scope.loading = true
  $rootScope.tab = "dashboard"

  # Events

  $scope.$on "events", (junk, events) -> 
    # for event in events
    #   $scope.stream.push event
    addEvents(events)
    $scope.$apply()
  $scope.$on "user", (junk, user) -> dashboard.addUser(user)
  $scope.$on "device", (junk, device) -> dashboard.addDevice(device)

  $scope.stream = []

  # Root data structure for dashboard

  $scope.state = {}
  $scope.dashboard = dashboard = new Dashboard()

  # open / close event groups (rules)

  dashboard.state.events = (id) ->
    if id == dashboard.state.rule
      dashboard.events.allDimension.top(500)

  toggleFilter = (name, id) ->
    dashboard.events["#{name}Dimension"].filterAll()
    if dashboard.state[name] == id
      dashboard.state[name] = null
    else
      dashboard.state[name] = null
      $scope.$apply()
      dashboard.state[name] = id
      dashboard.events["#{name}Dimension"].filter(id) #(id) (e) -> e == id
    $scope.updateMap()

  $scope.severityGroup = (severity) ->
    DashboardEvent.severityGroup(severity)

  $scope.toggleUser = (id) ->
    toggleFilter("user", id)

  $scope.toggleRule = (id) ->
    toggleFilter("rule", id)

  $scope.toggleCountry = (id) ->
    toggleFilter("country", id)


  $scope.updateMap = () ->
    colors =
      high: '#aa0000'
      medium: '#8e7669'
      low: '#c1b0a7'
    hiddenColors =
      high: '#f7e6e6'
      medium: '#e8e3e1'
      low: '#f3efed'

    countries = dashboard.events.country.all() || []
    vectorMap = $scope.map.vectorMap('get', 'mapObject')
    groups = {}
    for totals in countries
      severity = $scope.dashboard.severity.country[totals.key]
      severityGroup = $scope.severityGroup(severity)
      groups[totals.key] = if totals.value > 0 then colors[severityGroup] else hiddenColors[severityGroup]
    vectorMap.series.regions[0].setValues(groups)


  # Event display helpers

  $scope.displayAttributes = (event) ->
    console.log "disp attr"
    attrs = {countries: []}
    for k,v of event.payload
      attrs[k] = v
    attrs


  $scope.countries = (event) ->
    a = []


  # Event IO

  addEvents = (batch) ->
    #console.log "adding #{batch.length} events.."
    dashboard.addEvents(batch)
    $scope.updateMap()

  loadEvents = (limit=5000, offset=0) ->
    a = moment()
    DashboardEvent.query {offset: offset, limit: limit}, (data) ->
      console.log "events: loaded #{data.length} records"
      console.log "event load time 1: #{moment()-a}"
      addEvents(data)
      console.log "event load time 2: #{moment()-a}"
      if data.length == limit
        loadEvents(limit, offset+data.length) 
      else
        $scope.loading = false

  loadDashboard = (day) ->
    # load hours
    $scope.hourFormat = "ha"
    $scope.hours = []
    h = moment().local()
    h.hour(0)
    for i in [1..24]
      $scope.hours.push h.format($scope.hourFormat)
      h.hour(i)

    # load events
    loadEvents()

    # load users
    DashboardUser.query (data) ->
      console.log "users: loaded #{data.length} records"
      dashboard.addUser(user) for user in data
      $scope.$apply()

    # load devices
    DashboardDevice.query (data) ->
      console.log "devices: loaded #{data.length} records"
      dashboard.addDevice(device) for device in data
      $scope.$apply()
      
  loadDashboard()

DashboardCtrl.$inject = ['$scope', '$rootScope', '$routeParams', 'Dashboard', 'DashboardUser', 'DashboardDevice', 'DashboardEvent']
@app.controller 'DashboardCtrl', DashboardCtrl
