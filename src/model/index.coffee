mongoose = require 'mongoose'
module.exports =

  User : require './user'
  OAuthProfile : require './oauth_profile'

  ObjectId : (x) ->
    try
      new mongoose.Schema.Types.ObjectId x
    catch e
      null
