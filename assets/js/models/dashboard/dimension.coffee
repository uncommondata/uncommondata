@services.factory('DashboardDevice', ['$resource', ($resource) ->
  Device = $resource '/api/v1/dashboard/devices', {},
    query: {method:'GET', isArray: true}

  Device.prototype.name = ->
    @hostname || @ip

  Device
])