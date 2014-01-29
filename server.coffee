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
server.listen(process.env.PORT or 5000)

# SOCKET.IO INBOUND

EventProcessor = require('./app/processors/event_processor')
eventProcessor = new EventProcessor(redis)

count = 0
WebSocketServer = require('ws').Server
wss = new WebSocketServer(server: server)
wss.on 'connection', (ws) ->
  console.log "connect"
  console.log this.clients.length
  ws.on 'message', (message) ->
    data = JSON.parse(message)
    count += data.length
    console.log "websocket received #{count} events"
    for event in data
      eventProcessor.enqueue(event) 

console.log "websocket server created"
console.log("Listening for connections");

exports = module.exports = app
