module.exports = (doc) ->
  {
    _id: doc._id,
    _users: doc._users,
    _dev: doc._device,
    ts: doc.timestamp,
    name: doc.name,
    ips: (doc.ips.map (ip) -> {co: ip.country}),
    payload: doc.payload
  }
