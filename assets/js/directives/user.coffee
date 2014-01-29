@directives.directive "user", ->
  restrict: "E",
  controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
    user = {}
    for key in ["id", "name", "apikey"]
      user[key] = $attrs[key]
    $scope.setAppUser(user)
  ]
