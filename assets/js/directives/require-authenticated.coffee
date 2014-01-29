@directives.directive("requireAuthenticated", ['$location', ($location) ->
  {
    restrict: "E",
    transclude: true,
    template: "",
    link: ['$scope', '$element', ($scope, $element) -> 
      $location.path '/login' unless $scope.appUser
    ]
  }
])