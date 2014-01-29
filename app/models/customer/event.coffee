mongoose = require('mongoose')
moment = require('moment')

Mixed = mongoose.Schema.Types.Mixed
ObjectId = mongoose.Schema.Types.ObjectId

Schema = new mongoose.Schema
  _device:         {type: ObjectId},
  _users:          Array,
  name:            String,
  severity:        Number,
  payload:         Mixed,
  ips:             Mixed, # [{ip: "192...", ll: [x,y], city: "denver", region: "co", country: "US"}]
  date:            String,
  timestamp:       Date

for rel in ['user', 'account', 'device']
  do (rel) ->
    Schema
      .virtual(rel)
        .set (object) -> 
          this["_#{rel}"] = this["_cached#{rel}"] = object
        .get -> 
          this["_cached#{rel}"] || this["_#{rel}"]

Schema
  .pre 'save', (next) ->
    this.date = moment(this.timestamp).zone("00:00").format("YYYYMMDD")
    next()

Schema.set('toJSON', { virtuals: true })

Schema.index({timestamp: -1})

module.exports = -> Schema