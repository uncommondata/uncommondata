# passport.authenticate('localapikey', { failureRedirect: '/api/unauthorized' })

controller = {}
count = 0

controller.create = (req, res) ->
  count += 1
  console.log "api controller received #{count} events"
  e = req.body
  res.send("ok")
  @redis.lpush "api_event_queue", JSON.stringify(e), (err, reply) ->
    console.log err if err
  res.end()

module.exports = (redis) ->
  @redis = redis
  controller
