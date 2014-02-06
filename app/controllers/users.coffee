mongoose = require('mongoose')

login = (req, res) ->
  if (req.session.returnTo)
    res.redirect(req.session.returnTo)
    delete req.session.returnTo
    return
  res.redirect('/')

exports.authCallback = login
exports.session = login
exports.login = login

exports.logout = (req, res) ->
  req.logout()
  res.redirect("/")

exports.create = (req, res) ->
  user = new AppUser(req.body)
  user.save (err) ->
    if (err)
      req.body.errors = err.errors
      res.json req.body
    else
      res.json({})
