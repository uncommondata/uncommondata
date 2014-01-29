@services.factory('AppUser', ['$resource', ($resource) ->
  $resource '/users', {},
    create: {method:'POST'}
])