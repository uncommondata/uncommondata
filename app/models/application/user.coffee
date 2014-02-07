mongoose = require('mongoose')
uniqueValidator = require('mongoose-unique-validator')
crypto = require('crypto')
ObjectId = mongoose.Schema.Types.ObjectId
Company = mongoose.model('application.company')

acceptTerms = (val) ->
  val == true

Schema = new mongoose.Schema
  _company: { type: ObjectId, required: true, ref: "application.company" }
  email: { type: String, default: '', required: true, unique: true },
  name: { type: String, default: '', required: true },
  hashed_password: { type: String, required: true },
  salt: { type: String },
  terms: {type: Boolean, default: false, required: true, validate: acceptTerms }

Schema.plugin(uniqueValidator)

Schema
  .virtual('password')
    .set (password) ->
      this._password = password
      this.salt = this.makeSalt()
      this.hashed_password = this.encryptPassword(password)
    .get ->
      this._password

Schema
  .virtual('company_name')
    .set (name) ->
      if name && name.length > 1
        this.company = new Company({name: name})
        this._company = this.company.id
    .get ->
      this.company.name


Schema.methods = {
  authenticate: (plainText) ->
    this.encryptPassword(plainText) == this.hashed_password

  makeSalt: ->
    Math.round((new Date().valueOf() * Math.random())) + ''

  encryptPassword: (password) ->
    if password
      encrypred = crypto.createHmac('sha1', this.salt).update(password).digest('hex')
      return encrypred
    else
      ''
}

Schema.post "save", () ->
  # TODO - check to see if there's a pending invite... if so, use that instead
  this.company.save()

mongoose.model('application.user', Schema).ensureIndexes()

