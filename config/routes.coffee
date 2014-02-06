controllers = "../app/controllers"

users       = require("#{controllers}/users")
apiEvents   = require("#{controllers}/api/v1/dashboard/events")
apiUsers    = require("#{controllers}/api/v1/dashboard/users")
apiDevices  = require("#{controllers}/api/v1/dashboard/devices")

module.exports = (app, redis) ->
  # routes
  app.get  "/api/v1/dashboard/events",       apiEvents.index
  app.get  "/api/v1/dashboard/devices",      apiDevices.index
  app.get  "/api/v1/dashboard/users",        apiUsers.index

  app.post "/users",                         users.create
  app.get  "/logout", users.logout
  app.post "/sessions", passport.authenticate('local'), (req, res) -> 
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
      