# TODO - refactor to make data set a param

@directives.directive "dropdown", () ->
  restrict: "A"
  controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
    $element.dropdown()
  ]