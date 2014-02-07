# CORE

require('./config/mongoose')
require('./config/models')

global._               = require('underscore')
global.moment          = require('moment')
global.ArrayFormatter  = require('./lib/array_formatter')
global.Rand            = require('./lib/rand')
global.passport        = require('./config/passport')()

http                   = require('http')
express                = require('express')
eventListener          = require('./app/io/event_listener')

config = {redis: {}}
redis = require('./config/redis')(config.redis)

# CONFIGURE

app = express()
require('./config/express')(app, config)
require('./config/routes')(app, redis)

# EXPRESS HTTP + SOCKET.IO

port = process.env.PORT or 5000

server = http.createServer(app)
eventListener.listen(server, redis)
server.listen(port)
