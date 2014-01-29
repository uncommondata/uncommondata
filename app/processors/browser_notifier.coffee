# TODO - Make the customer id lookup a LRU cache

class BrowserNotifier
  constructor: (@redis, @pusher) ->
    # note, pusher is old
    # Event.remove().exec()
    @queueName = "browser_event_queue"
    @eventsProcessed = 0    

  start: () =>
    @timerId = setInterval =>
      @checkQueue()
    , 1000, 1000

    @sizeTimerId = setInterval =>
      @redis.llen @queueName, (err, value) =>
        console.log "browser queue size: #{value}"
    , 60000, 60000
    @

  stop: () =>
    clearInterval(@timerId)
    clearInterval(@sizeTimerId)

  enqueue: (channel, event) =>
    @redis.lpush @queueName, JSON.stringify({channel: channel, event: event}), (err, reply) =>
      console.log err if err

  checkQueue: (events=[]) =>
    count = 0
    @redis.lpop @queueName, (err, value) =>
      if value
        data = JSON.parse(value)
        events.push(JSON.parse value)
        @checkQueue(events)
      else
        @processEvents(events)


  processEvents: (events) =>
    queues = {}
    for e in events
      channel = e.channel
      event = e.event
      queue = queues[channel] ||= []
      queue.push(event)
      if queue.length >= 20
        @deliverEvents(channel, queue.slice(0))
        queue.length = 0

    @deliverEvents(channel, queue) for channel, queue of queues
        


  deliverEvents: (channel, events) =>
    console.log "browser notifier: publishing #{events.length} events to #{channel}"
    mapped = _.map events, (event) -> eventPresenter(event)
    @pusher.trigger channel, 'event', mapped
    

module.exports = BrowserNotifier
