express = require 'express'
_ = require 'underscore'

Data = require './data'

app = new express

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

module.exports = app
