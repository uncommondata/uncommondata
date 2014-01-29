MarketingCtrl = ($scope, $rootScope, $location) ->
  if $rootScope.user
    $location.path '/dashboard'

MarketingCtrl.$inject = ['$scope', '$rootScope', '$location']
@app.controller 'MarketingCtrl', MarketingCtrl