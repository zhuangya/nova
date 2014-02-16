db = require 'mongoose'
timestamps = require 'mongoose-timestamp'
_ = require 'underscore'
Product = require '../product'


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

schema.methods.updateInventory = ->
  _.chain(@content)
    .map (item) ->
      p = Product.loadItem item.name
      if p.getInventory() < item.count
        throw new Error "Out of stock: #{item.name}"
      else
        p.updateInventory(-item.count)
      p
    .invoke 'save'

module.exports = db.model 'Order', schema


