DashboardEventsCtrl = ($scope) ->
  setInterval ->
    $scope.$apply()
  , 10000, 10000

DashboardEventsCtrl.$inject = ['$scope']
@app.controller 'DashboardEventsCtrl', DashboardEventsCtrl