JoinCtrl = ($scope, $location, AppUser) ->
  $scope.user = new AppUser({terms:false})
  $scope.$apply()
  $scope.save = () ->
    $scope.user.$save (result) ->
      if result.errors
        $scope.user.errors = result.errors
      else
        $scope.setAppUser(result)
        $location.path '/dashboard'

JoinCtrl.$inject = ['$scope', '$location', 'AppUser']
@app.controller 'JoinCtrl', JoinCtrl