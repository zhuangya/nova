auth = require './auth'
express = require 'express'
fibrous = require 'fibrous'
_ = require 'underscore'

app = express()

#app.use auth.checkHeader
cart = require './cart'
order = require './order'
admin = require './admin'

app.get '/user', fibrous.middleware, (req,resp) ->
  if req.user
    #console.info req.user
    req.user.populate('profile', (err,user) ->
      #console.info err
      resp.json user
    )
  else
    resp.send 403,
      errno: 403,
      errmsg: 'Login required'

app.get '/', (req,resp) -> resp.render('api.jade')

app.get    '/cart', fibrous.middleware, cart.get
app.post   '/cart', fibrous.middleware, cart.update
app.post   '/cart/delete', fibrous.middleware, cart.remove

app.get    '/order', fibrous.middleware, order.list
app.post   '/order', fibrous.middleware, order.create

app.get    '/order/:id', fibrous.middleware, order.get
app.post   '/order/:id', fibrous.middleware, order.update
app.delete '/order/:id', fibrous.middleware, order.remove

app.post   '/order/:id/submit', fibrous.middleware, order.sendToAlipay

app.use '/admin', admin

app.all '/test', (req,resp) ->
  resp.send method: req.method

module.exports = ()-> app
