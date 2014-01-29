# TODO - refactor to make data set a param

@directives.directive "donut", ->
  restrict: "E"
  link: ($scope, $element, $attrs) ->
    ndx = crossfilter(experiments)
    chart = dc.pieChart("#donut");
    chart
      .width(400)
      .height(400)
      .innerRadius(100)
      .render()
