redis = require('redis')

module.exports = (config={}) ->
  url = process.env.REDIS_URL or "redis://127.0.0.1:6379"
  url = url.replace 'redis://', ''
  if url.indexOf('@') > 0
    match = /(.*)@(.*):(\d+)/.exec(url)
    password = match[1]
    config.password = password.replace /^.*?:/, ''
    config.host = match[2]
    config.port = match[3]
  else
    match = /(.*):(\d+)/.exec(url)
    config.host = match[1]
    config.port = match[2]

  client = redis.createClient(config.port, config.host);
  client.auth(config.password) if config.password
  client