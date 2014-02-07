# EVENT PIPELINE

require('./config/mongoose')
require('./config/models')

global._                = require('underscore')
global.geoip            = require('geoip-lite')
redis                   = require('./config/redis')()
pusher                  = require('./config/pusher')()
BrowserNotifier         = require('./app/io/browser_notifier')
EventProcessor          = require('./app/io/event_processor')

global.browserNotifier  = new BrowserNotifier(redis, pusher).start()
eventProcessor = new EventProcessor(redis, pusher).start()
