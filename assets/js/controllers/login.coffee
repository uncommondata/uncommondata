LoginCtrl = ($scope, $location, Session) ->
  $scope.session = new Session()
  $scope.authentication = true
  $scope.save = () ->
    $scope.session.$save (result) ->
      $scope.setAppUser(result)
      $location.path '/dashboard'      
    , (result) ->
      $scope.session.errors = true

LoginCtrl.$inject = ['$scope', '$location', 'Session']
@app.controller 'LoginCtrl', LoginCtrl