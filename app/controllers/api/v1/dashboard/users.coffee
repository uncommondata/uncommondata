global.DashboardUsersController = 
  index: (req, res) ->
    req.user._company.schemas().User.find (err, records) ->
      res.send(JSON.stringify records)
