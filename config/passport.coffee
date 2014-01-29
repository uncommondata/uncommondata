passport = require('passport')
mongoose = require('mongoose')

module.exports = () ->
  LocalStrategy = require('passport-local').Strategy
  LocalAPIKeyStrategy = require('passport-localapikey').Strategy

  passport.serializeUser (user, done) -> done(null, user.id)
  passport.deserializeUser (id, done) -> 
    AppUser.findOne({ _id: id }).populate("_company").exec (err, user) -> 
      done(err, user)

  # Username and password
  strategy = new LocalStrategy {usernameField: 'email', passwordField: 'password'}, (email, password, done) ->
    AppUser.findOne({ email: email }).populate("_company").exec (err, user) ->
      return done(err) if (err)
      return done(null, false, { message: 'Unknown user' }) unless user
      return done(null, false, { message: 'Invalid password' }) unless user.authenticate(password)
      return done(null, user)
  passport.use(strategy)

  # API key
  strategy = new LocalAPIKeyStrategy (apikey, done) ->
    AppUser.findOne {apikey: apikey}, (err, user) ->
      if (err) 
        done(err)
      else if (!user) 
        done(null, false) 
      else
        done(null, user)
  passport.use strategy

  passport