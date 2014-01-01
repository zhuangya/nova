db = require 'mongoose'
timestamps = require 'mongoose-timestamp'

schema = db.Schema
  ownner: #User ID
    type: db.Schema.Types.ObjectId
    ref: "User"
    index: true
    required: true
  address: db.Schema.Types.Mixed
  status: String
  total_price: Number
  content:
    type: db.Schema.Types.Mixed
    required: true
  
schema.plugin(timestamps)

schema.statics.findByUser = (uid, cb) ->
  #console.info projectId
  @find {'ownner': uid},cb

module.exports = db.model 'Order', schema


