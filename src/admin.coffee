express = require 'express'

Data = require './data'

app = new express

app.post '/video', (req,resp) ->
  videos = (Data.load 'video.json') or []
  v = req.body
  return resp.send 400,"Not an object" unless typeof v is "object"
  return resp.send 400,"Missing name prop" unless v.name
  return resp.send 400,"Missing url prop" unless v.url
  return resp.send 400,"Not youku video" unless v.url.match /http:\/\/v\.youku\.com\/v_show\/id_\w+\.html/
  videos.push v
  Data.writeJSON 'video.json', videos
  resp.send videos

app.post '/data', (req,resp) ->
  product = new Product req.body
  product.validate()
  product.save()
  resp.json product

app.post '/data/reload', (req,resp) ->

app.post '/data/:id', (req,resp) ->
  product = Product.load req.params.id
  for name,value in req.body
    product[name] = value
  product.validate()
  product.save()
  resp.json product

app.post '/data/:id/upload', (req,resp) ->
  
app.get '/order', (req,resp) ->

app.get '/order/:id', (req,resp) ->

app.post '/order/:id', (req,resp) ->
  

module.exports = app
