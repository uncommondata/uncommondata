# EVENT PIPELINE

global._ = require('underscore')
global.eventPresenter = require('./lib/event_presenter')

require('./config/geoip')

redis = require('./config/redis')()

require('./config/mongoose')
require('./config/models')

redis.llen "event_queue", (e,val) ->
  console.log "Queue size: #{e}, #{val}"

pusher = require('./config/pusher')()
BrowserNotifier = require('./app/processors/browser_notifier')
global.browserNotifier = browserNotifier = new BrowserNotifier(redis, pusher).start()

EventProcessor = require('./app/processors/event_processor')
eventProcessor = new EventProcessor(redis, pusher).start()
