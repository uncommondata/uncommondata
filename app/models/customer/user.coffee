mongoose = require('mongoose')
Mixed = mongoose.Schema.Types.Mixed
ObjectId = mongoose.Schema.Types.ObjectId

Schema = new mongoose.Schema
  groupId:     ObjectId,
  identifier:  String,
  username:    String,
  email:       String,
  position:    String,
  firstName:   String,
  lastName:    String,
  pictureUrl:  String

Schema.index({identifier: 1}, {unique: true})

Schema.virtual('name').get =>
  if @firstName
    @firstName + ' ' + @lastName
  else
    @username

Schema.set('toJSON', { virtuals: true })

Schema.index({identifier: 1}, {unique:true, sparse: true})

module.exports = -> Schema
