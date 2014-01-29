@services.factory('Session', ['$resource', ($resource) ->
  $resource '/sessions', {},
    create: {method:'POST'}
])