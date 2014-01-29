@services.factory('DashboardEvent', ['$resource', ($resource) ->
  Event = $resource '/api/v1/dashboard/events', {limit: "1000", offset: "0"},
    query: {method:'GET', isArray: true}

  Event.severityGroup = (severity) ->
    group = switch
      when severity <= 5 
        "low"
      when severity <= 10 
        "medium"
      else 
        "high"
    group


  Event.prototype.loaded = () ->
    if @ts
      @moment = moment(new Date(@ts)).local()
    else
      @moment = moment()

    if @payload
      severity = @payload.severity
      @severityGroup = Event.severityGroup(severity)
    else
      @severityGroup = "high"

  Event.prototype.timeAgo = ->
    ta = (moment() - @moment)/1000
    if (ta < 60)
      "just now"
    else if (ta < 3600)
      "#{parseInt(ta/60)}m ago"
    else if (ta <= 86400)
      "#{parseInt(ta/3600)}h ago"
    else
      "#{parseInt(ta/86400)}d ago"

  Event
])