@services = angular.module('app.services', ['ngResource'])
@directives = angular.module('app.directives', [])
@filters = angular.module('app.filters', [])

@app = angular.module "app", ['ngAnimate', 'ngRoute', 'ngResource', 'ngSanitize', 'app.services', 'app.directives', 'app.filters']
@app.config(['$locationProvider', ($locationProvider) => $locationProvider.html5Mode(true) ])
@app.config(["$httpProvider", (provider) => 
  provider.defaults.headers.common['Content-Type'] = 'application/json'
  provider.defaults.headers.post['Content-Type'] = 'application/json'
  provider.defaults.headers.put['Content-Type'] = 'application/json'
])

