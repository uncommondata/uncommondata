LogoutCtrl = ($scope, $location) ->
  $.get "/logout", (r) ->
    $scope.setAppUser(null)
    $location.path("/login")
    $scope.$apply()

LogoutCtrl.$inject = ['$scope', '$location']
@app.controller 'LogoutCtrl', LogoutCtrl