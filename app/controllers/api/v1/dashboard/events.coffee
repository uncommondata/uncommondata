global.DashboardEventsController =
  index: (req, res) ->
    offset = req.query.offset
    limit = req.query.limit || 1000
    limit = 0 if limit > 10000

    Event = req.user._company.schemas().Event
    ts = moment()
    ts.startOf('day')
    query = {timestamp: {$gte: ts.toDate() }}

    res.contentType('json')
    format = new ArrayFormatter()
    fields = "_id _users _device timestamp name ips payload"
    a = moment()
    stream = Event.find(query).batchSize(1000).sort({timestamp: -1}).limit(limit).skip(offset).select(fields).lean(true).stream()
    stream.pipe(format).pipe(res)
    stream.on 'close', ->
      console.log moment()-a
      res.end()