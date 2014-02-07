EventProcessor = require('./event_processor')
count = 0

exports.listen = (server, redis) ->
  eventProcessor = new EventProcessor(redis)
  io = require('socket.io').listen(server)
  io.sockets.on 'connection', (socket) ->
    apikey = null
    socket.on 'identify', (id, callback) ->
      if id
        Company.findOne { apikey: id }, (err, user) ->
          if user
            apikey = id
            callback('ok')
          else
            callback('invalid credentials')

    socket.on 'message', (message) ->
      console.log apikey
      if message
        console.log "websocket received #{message.length} events, #{count} total"
        for event in message
          if event
            count += 1
            event.account = apikey if apikey
            eventProcessor.enqueue(event) 

    socket.on 'disconnect', -> #
