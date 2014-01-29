@directives.directive "toggleClass", ->
  restrict: "A",
  link: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) -> 
    $element.click ->
      $element.toggleClass($attrs.toggleClass)
  ]