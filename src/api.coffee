auth = require './auth'
express = require 'express'
fibrous = require 'fibrous'

app = express()

#app.use auth.checkHeader
cart = require './cart'

app.get '/cart', fibrous.middleware, cart.get

app.post '/cart', fibrous.middleware, cart.update

app.delete '/cart', fibrous.middleware, cart.remove

###
app.get '/order', fibrous.middleware, order.get

app.post '/order', fibrous.middleware, order.create
###

#app.post '/photo/profileIcon', fibrous.middleware, ctrl.photo.createProfileIcon

app.all '/test', (req,resp) ->
  resp.send method: req.method

module.exports = ()-> app
