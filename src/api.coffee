auth = require './auth'
express = require 'express'
fibrous = require 'fibrous'
passport = require 'passport'
_ = require 'underscore'
exec = require('child_process').exec

app = express()

#app.use auth.checkHeader
cart = require './cart'
order = require './order'
admin = require './admin'

User = require './model/user'

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

app.post '/register', fibrous.middleware, (req,resp) ->
  user = new User req.body
  user.sync.save()
  req.session.user = user._id
  resp.json user

app.post '/login',fibrous.middleware, (req,resp,next) ->
  (passport.authenticate 'local', (err,user,info) ->
    if user
      req.sync.logIn user,{}
      return resp.json
        ok:true
        user:user
    else
      return resp.json
        ok:false
        msg:info
        err:err
  )(req,resp,next)

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

app.get '/bg', (req, resp) ->
  exec("cd #{__dirname}/../data/page-bgs/;find . -type f -print0", (err, bgs) ->
    bgs = bgs.split '\0'
    resp.send(_.chain(bgs)
      .filter (bg) ->
        /(?:jpe?g|png|gif)/.test bg
      .map (bg) ->
        bg = bg.replace /\.\//, ''
        name: bg.split('.')[0],
        path: "/data/page-bgs/#{bg}"
      .value())
  )

app.all '/test', (req,resp) ->
  resp.send method: req.method

module.exports = ()-> app
