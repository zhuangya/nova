express = require 'express'

Data = require './data'

app = new express

app.post '/video', (req,resp) ->
  videos = (Data.load 'video.json') or []
  v = req.body
  return resp.send 400,"Not an object" unless typeof v is "object"
  return resp.send 400,"Missing name prop" unless v.name
  return resp.send 400,"Missing url prop" unless v.url
  videos.push v
  Data.writeJSON 'video.json', videos
  resp.send videos
module.exports = app
