exports.index = (req, res) ->
  offset = req.query.offset
  limit = req.query.limit || 1000
  limit = 0 if limit > 10000
  console.log "0"
  Event = req.user._company.schemas().Event
  console.log "1"
  ts = moment()
  console.log "2"
  ts.startOf('day')
  console.log "3"
  query = {timestamp: {$gte: ts.toDate() }}
  console.log "4"
  console.log ArrayFormatter
  res.contentType('json')
  format = new ArrayFormatter()
  fields = "_id _users _device timestamp name ips payload"
  a = moment()
  stream = Event.find(query).batchSize(1000).sort({timestamp: -1}).limit(limit).skip(offset).select(fields).lean(true).stream()
  stream.pipe(format).pipe(res)
  stream.on 'close', ->
    console.log "stream processed in #{moment()-a}"
    res.end()