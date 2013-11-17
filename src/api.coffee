auth = require './auth'
express = require 'express'
fibrous = require 'fibrous'

app = express()

#app.post '/photo/profileIcon', fibrous.middleware, ctrl.photo.createProfileIcon

app.all '/test', (req,resp) ->
  resp.send method: req.method
module.exports = app
