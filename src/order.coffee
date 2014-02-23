{Order} = require './model'
Cart = require './cart'

alipay = require './alipay'
utils = require './utils'

_ = require 'underscore'

class OrderManager

  list: (req,resp) ->
    resp.json Order.sync.findByUser req.user._id

  get: (req,resp) ->
    resp.json Order.sync.findById req.params.id

  create: (req,resp)->
    cart = Cart.load req
    price = cart.getTotalPrice()
    order = new Order
      ownner: req.user
      content: cart.items
      total_price: price

    try
      order.updateInventory()
      resp.json order.sync.save()
    catch
      resp.json 500, err:_error.toString()

  update: (req,resp)->
    order = Order.sync.findById req.params.id
    order.address = req.body.address
    resp.json order.sync.save()
    
  remove: (req,resp)->
    order = Order.sync.findById req.params.id
    order.remove()
    resp.json order

  sendToAlipay: (req,resp) ->
    order = Order.sync.findById req.params.id
    data = {
      out_trade_no: order.id
      subject: "Benzex Order "+order.id
      price: order.total_price
      quantity: 1
      logistics_fee: "0"
      logistics_type: "EXPRESS"
      logistics_payment: "SELLER_PAY"
      body: _.chain(order.content).pluck('name').join(";").value()
      show_url: utils.getURL("/orders/#{order.id}")
      receive_name    : ""
      receive_address : ""
      receive_zip     : ""
      receive_phone   : ""
      receive_mobile  : ""
    }
    alipay.create_partner_trade_by_buyer(data,resp)

alipay.on 'partner_trade_notify', (oid,txid,params) ->
  console.info "notify #{oid} - #{txid}",params
  Order.findById oid, (err,order) ->
    return console.info err.stack if err
    #order.status = 'complete'
    order.payment = params
    order.save (err,obj) ->
      return console.info err.stack if err
      console.info "order #{oid} updated"

module.exports=new OrderManager
