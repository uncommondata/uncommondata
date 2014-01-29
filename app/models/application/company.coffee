mongoose = require('mongoose')
uniqueValidator = require('mongoose-unique-validator')
crypto = require('crypto')

Schema = new mongoose.Schema
  name: { type: String, required: true },
  apikey: { type: String, default: null }

Schema.methods.generateToken = ->
  @apikey = crypto.createHash('md5').update(@email + Date().toString()).digest("hex");

Schema.methods.ensureSchemaIndexes = ->
  for schema in @schemas()
    schema.ensureIndexes()

Schema.methods.schemas = ->
  unless @_schemas
    console.log "loading schemas for #{@name}"
    @_schemas = {}
    for name, schemaz of metaSchemas
      @_schemas[name] = mongoose.model("customer.#{@apikey}.#{name}", schemaz)
  @_schemas

Schema.pre "save", (next) ->
  @generateToken() unless @apikey
  next()

Schema.post "save", (company) ->
  @ensureSchemaIndexes()

mongoose.model('application.company', Schema).ensureIndexes()