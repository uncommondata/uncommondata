@directives.directive("requireAnonymous", ['$location', ($location) ->
  {
    restrict: "E",
    transclude: true,
    template: "",
    link: ['$scope', '$element', ($scope, $element) -> 
      $location.path '/dashboard' if $scope.appUser
    ]
  }
])