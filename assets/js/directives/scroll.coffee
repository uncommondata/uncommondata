@directives.directive "scroll", () ->
  restrict: "A",

  link: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) -> 
    element.on "click", (e) ->
      e.preventDefault()
      anchor = attrs.scroll
      anchor = 0 if $(anchor).length == 0
      $.scrollTo(anchor, "slow")
      element.addClass("active").siblings().removeClass("active")
  ]