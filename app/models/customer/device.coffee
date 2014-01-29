Mixed = mongoose.Schema.Types.Mixed
ObjectId = mongoose.Schema.Types.ObjectId

Schema = new mongoose.Schema
  identifier:  String,
  ip:          String,
  hostname:    String

Schema.index({identifier: 1}, {unique: true})

Schema.set('toJSON', { virtuals: true })

Schema.index({identifier: 1}, {unique:true, sparse: true})

module.exports = () -> Schema
