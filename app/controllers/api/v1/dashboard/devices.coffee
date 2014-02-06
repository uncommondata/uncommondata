exports.index = (req, res) ->
  req.user._company.schemas().Device.find (err, records) ->
    res.send(JSON.stringify records)
