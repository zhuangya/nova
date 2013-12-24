db = require 'mongoose'
timestamps = require 'mongoose-timestamp'
#gravatar = require 'gravatar'
config = require '../../config'

schema = db.Schema
  id:
    type: String
    required: true
    unique: true
  provider:
    type: String
  token:
    type: db.Schema.Types.Mixed
    required: true
  _json:
    type: db.Schema.Types.Mixed
  _user:
    type: db.Schema.Types.ObjectId
    index: true
    ref: 'User'

schema.plugin(timestamps)

schema.statics.createOrUpdate = (profile,cb) ->
  condition = id: "#{profile.provider}_#{profile.id}"
  @findOne condition,(err,obj)=>
    return cb err,null if err
    obj = obj or new this(condition)
    obj.provider = profile.provider
    obj.token = profile.token
    obj._json = profile._json
    obj.save(cb)

schema.virtual('name').get ()->
  switch @provider
    when "twitter" then @_json.name
    when "google" then @_json.name
    when "facebook" then @_json.name
    else ""

schema.virtual('email').get ()->
  switch @provider
    when "google" then @_json.email
    when "facebook" then @_json.email
    else ""

schema.virtual('profile_image').get ()->
  switch @provider
    when "twitter" then @_json.profile_background_image_url
    when "google" then @_json.picture
    else ""


module.exports = db.model 'OAuthProfile', schema


