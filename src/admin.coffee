express = require 'express'
_ = require 'underscore'
exec = require('child_process').exec
config = require '../config'
fs = require 'fs'

Data = require './data'
Product = require './product'
{User} = require './model'

app = new express

app.post '/bg', (req, resp) ->

  fs.readFile req.files.background.path, (err, image) ->
    throw err if err
    bgPath = "#{__dirname}/../data/page-bgs/#{req.body.slug}.jpg"
    fs.writeFile bgPath, image, (err) ->
      throw err if err
      resp.send
        path: bgPath.split('..')[1]

app.post '/video', (req,resp) ->
  videos = (Data.load 'video.json') or []
  v = req.body
  id = '' + +new Date()
  return resp.send 400,"Not an object" unless typeof v is "object"
  return resp.send 400,"Missing name prop" unless v.name
  return resp.send 400,"Missing url prop" unless v.url
  return resp.send 400,"Not youku video" unless v.url.match /http:\/\/v\.youku\.com\/v_show\/id_\w+\.html/
  v.id = id
  videos.push v
  Data.writeJSON 'video.json', videos
  resp.send videos

app.post '/video/delete', (req,resp) ->
  videos = (Data.load 'video.json') or []

  v = req.body

  videos = _.reject videos, (video) ->
    +video.id is +v.id

  Data.writeJSON 'video.json', videos

  resp.send videos

app.get '/data', (req,resp) ->
  exec("cd #{};find . -type d -print0", (err,sout) ->
    resp.json sout.split('\0')
  )

app.post '/data', (req,resp) ->
  product = new Product req.body
  console.info product
  product.validate(product.id,false)
  product.save()
  resp.json product

app.post '/data/reload', (req,resp) ->
  exec("cd #{config.baseDir}; find data -name metadata.yml | coffee src/mkindex.coffee > data/index.json.new && mv -f data/index.json.new data/index.json", (err,stdout,stderr) ->
    resp.end stderr
  )

app.post '/data/:cat/:id', (req,resp) ->
  id = req.params.cat + "/" + req.params.id
  product = Product.loadProduct id
  for name,value of req.body
    product[name] = value
  product.validate(product.id,false)
  product.save()
  resp.json product

app.post '/data/:cat/:id/delete', (req,resp) ->
  id = req.params.cat + "/" + req.params.id
  product = Product.loadProduct id
  exec("cd #{config.baseDir}/data; rm -rf #{id}", (err) ->
    resp.json product
  )

app.post '/data/:cat/:id/upload', (req,resp) ->
  return resp.send 400,"missing payload" unless req.files?.payload
  return resp.send 400,"missing name" unless req.body.name

  id = req.params.cat + "/" + req.params.id
  #id = req.body.id
  product = Product.loadProduct id
  payload = req.files.payload
  name = req.body.name
  dst = product.getPath(name)
  fs.createReadStream(payload.path)
    .on('end', ->
      fs.unlinkSync(payload.path)
      resp.json
        path: "/#{product.id}/#{name}"
    ).pipe fs.createWriteStream dst

app.get '/order', (req,resp) ->
  resp.json Order.sync.find()

app.get '/order/:id', (req,resp) ->
  resp.json Order.sync.findById req.params.id

app.post '/order/:id', (req,resp) ->
  order = Order.sync.findById req.params.id
  for k,v of req.body
    order[k]=v
  resp.json order.sync.save()

app.get '/users', (req,resp) ->
  page = req.query.page || 0
  size = req.query.size || 30

  User.find().skip(page*size).limit(size).populate('profile').exec((err,obj) ->
    return resp.json 500,err if err
    resp.json obj
  )

module.exports = app
