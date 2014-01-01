Product = require './product'
_ = require 'underscore'

class Cart
  @load: (req) =>
    cart = req.session.cart
    return new @(cart) if cart
    new @(req.session.cart = {})

  @get: (req,resp) =>
    resp.json @load req

  @update: (req, resp) =>
    items = req.body
    items = [items] unless items instanceof Array
    cart = @load req
    for item in items
      product = Product.loadItem item.name
      item.unit_price = product.getPrice()
      console.info item
      cart.items[item.name] = item
    resp.json cart

  @remove: (req, resp) =>
    item = req.body
    cart = @load req
    delete cart.items[item.name]
    resp.json cart

  constructor: (@items) ->

  toJSON: ->
    @items[name] for name of @items

  getTotalPrice: ->
    _.chain @items
     .map (item)->
       product = Product.loadItem item.name
       product.getPrice() * item.count
     .reduce ((a,b)->a+b),0

module.exports=Cart

