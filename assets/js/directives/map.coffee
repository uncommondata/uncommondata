# TODO - refactor to make data set a param

@directives.directive "map", () ->
  restrict: "E"
  controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
    $scope.map = $element
    $scope.map.vectorMap
      zoomOnScroll: false
      backgroundColor: "none"
      regionStyle:
        initial:
          fill: '#ddd'
      series: 
        regions: [{
          attribute: 'fill'
        }]

      onRegionClick: (event, index) ->
        $scope.toggleCountry(index)
        $scope.$apply()

      onRegionOver: (event, index) ->
        $scope.$apply()

      onRegionOut: (event) ->
        $scope.$apply()

    $attrs.$observe "count", (v) ->
      $scope.updateMap()
  ]