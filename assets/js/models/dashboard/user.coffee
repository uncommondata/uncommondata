@services.factory('DashboardUser', ['$resource', ($resource) ->
  User = $resource '/api/v1/dashboard/users', {},
    query: {method:'GET', isArray: true}

  User.prototype.name = ->
    if @firstName 
      "#{@firstName} #{@lastName}"
    else if @username
      @username
    else
      null

  User.prototype.photo = ->
    "/images/users/default.png"

  User
])