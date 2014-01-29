@directives.directive("sticky", ['$window', ($window) ->
  controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
    $win = angular.element($window)
    if $scope._stickyElements is `undefined`
      $scope._stickyElements = []
      $win.bind "scroll.sticky", (e) ->
        pos = $win.scrollTop()
        for item in $scope._stickyElements
          if not item.isStuck and pos > item.start
            item.element.addClass "stuck"
            item.isStuck = true
            item.placeholder = angular.element("<div></div>").css(height: item.element.outerHeight() + "px").insertBefore(item.element)  if item.placeholder
          else if item.isStuck and pos < item.start
            item.element.removeClass "stuck"
            item.isStuck = false
            if item.placeholder
              item.placeholder.remove()
              item.placeholder = true

      recheckPositions = ->
        for item in $scope._stickyElements
          unless item.isStuck
            item.start = item.element.offset().top
          else if item.placeholder
            item.start = item.placeholder.offset().top

      $win.bind "load", recheckPositions
      $win.bind "resize", recheckPositions

    setTimeout ->
      item =
        element: $element
        isStuck: false
        placeholder: $attrs.usePlaceholder isnt `undefined`
        start: $element.offset().top
      $scope._stickyElements.push item
    , 100
  ]
])