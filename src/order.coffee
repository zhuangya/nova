{Order} = require './model'
Cart = require './cart'

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
      status: 'new'
      address: req.body.address

    order.updateInventory()
    resp.json order.sync.save()

  update: (req,resp)->
    order = Order.sync.findById req.params.id
    order.address = req.body.address
    resp.json order.sync.save()
    
  remove: (req,resp)->
    order = Order.sync.findById req.params.id
    order.remove()
    resp.json order

module.exports=new OrderManager
