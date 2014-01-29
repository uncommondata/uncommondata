express = require('express')
pipeline = require('connect-assets')()
flash = require('connect-flash')
RedisStore = require('connect-redis')(express)

module.exports = (app, config) ->
  app.set 'views', __dirname + '/../app/views'
  app.set 'view engine', 'jade'
  app.use express.compress()
  app.use express.static('public')
  app.use express.bodyParser()
  app.use express.cookieParser("jerry was a racecar driver")
  app.use express.session({
    store: new RedisStore
      host: config.redis.host,
      port: config.redis.port,
      pass: config.redis.password
    secret: 'he drove so god damned fast'
  })
  app.use passport.initialize()
  app.use passport.session()
  app.use pipeline

  # app.user flash()
