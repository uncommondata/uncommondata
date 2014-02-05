# CORE

require('./lib/array_formatter')
global._ = require('underscore')
global.eventPresenter = require('./lib/event_presenter')
global.moment = require('moment')

require('./config/mongoose')
require('./config/models')

global.passport = require('./config/passport')()

config = {redis: {}}
redis = require('./config/redis')(config.redis)

# DEPENDENCIES

http = require('http')
express = require('express')

# EXPRESS

app = express()
require('./config/express')(app, config)
require('./config/routes')(app, redis)

# EXPRESS HTTP + SOCKET.IO

server = http.createServer(app)

# SOCKET.IO INBOUND

EventProcessor = require('./app/processors/event_processor')
eventProcessor = new EventProcessor(redis)

count = 0
io = require('socket.io').listen(server)
io.sockets.on 'connection', (socket) ->
  socket.on 'message', (message) ->
    if message
      count += message.length
      console.log "websocket received #{message.length} events, #{count} total"
      for event in message
        eventProcessor.enqueue(event) 

  socket.on 'disconnect', -> #

port = process.env.PORT or 5000
server.listen(port)
console.log("Listening for connections on #{port}");

exports = module.exports = app
