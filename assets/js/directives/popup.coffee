# TODO - refactor to make data set a param

@directives.directive "popup", () ->
  restrict: "A"
  controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
    # $element.popup({position: "left center"})
  ]