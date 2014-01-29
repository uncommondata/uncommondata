RootCtrl = ($scope, $location, DashboardEvent, DashboardUser) ->
  $scope.eventCount = 0
  $scope.eventTimeoutId = null

  $scope.$on "$routeChangeSuccess", (e, route) -> 
    page = $location.path().replace(/^\//, '').split("/").shift()
    $scope.page = {
      join: page == 'join'
      login: page == 'login'
      dashboard: page == 'dashboard'
    }

  configurePusher = (appUser) ->
    pusher = new Pusher('46fe9eb97e2b81eafda0')
    channel = pusher.subscribe(appUser.apikey)
    console.log "subscribed to #{appUser.apikey}"

    channel.bind 'event', (data) -> 
      events = data.map (e) -> new DashboardEvent(e)
      $scope.$broadcast('events', events) 

    # channel.bind 'device', (data) -> 
    #   $scope.$broadcast('device', new data)

    channel.bind 'user', (data) -> 
      $scope.$broadcast('user', new DashboardUser(data)) 

  $scope.setAppUser = (appUser) ->
    if appUser
      if appUser.id
        $scope.appUser = appUser 
        configurePusher(appUser)
      if $location.path() == "/"
        if appUser.id
          $location.path("/dashboard")
        else
          $location.path("/login")
    else
      $scope.appUser = null

RootCtrl.$inject = ['$scope', '$location', 'DashboardEvent', 'DashboardUser']
@app.controller 'RootCtrl', RootCtrl