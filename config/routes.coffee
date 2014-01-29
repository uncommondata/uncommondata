controllers = "../app/controllers"
require("#{controllers}/api/v1/dashboard/events")
require("#{controllers}/api/v1/dashboard/users")
require("#{controllers}/api/v1/dashboard/devices")

module.exports = (app, redis) ->
  # require controllers
  app_users  = require "#{controllers}/app_users"
  events = require("#{controllers}/api/v1/events")(redis)

  # routes
  app.get  "/api/v1/dashboard/events",       DashboardEventsController.index
  app.get  "/api/v1/dashboard/devices",      DashboardDevicesController.index
  app.get  "/api/v1/dashboard/users",        DashboardUsersController.index
  app.post "/api/v1/events",                 events.create
  app.post "/users",                         app_users.create
  
  app.get('/logout', app_users.logout)
  app.post '/sessions', passport.authenticate('local'), (req, res) -> 
    user = req.user
    json = {id: user.id, apikey: user._company.apikey, name: user.name}
    res.json(json)

  # for rendering Angular views
  app.get '/templates/*', (req, res) -> res.render(req.params[0])

  app.use (req,res,next) ->
    renderIndex = true
    for route in ["assets", "api/", "/users", "logout", "/sessions"]
      renderIndex = false if req.path.match(route)
    renderIndex = true if req.path.match("/dashboard/")

    if renderIndex
      res.render('index', {user: req.user})

    else
      next()
      