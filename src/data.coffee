express = require 'express'
_ = require 'underscore'
im = require 'imagemagick'
fs = require 'fs'
url = require 'url'
path = require 'path'
events = require 'events'
mkdirp = require 'mkdirp'
YAML = require 'js-yaml'
YAML.parse = (str) ->
  str = str.toString() if Buffer.isBuffer(str)
  @safeLoad str

config = require '../config'
Product = require './product'

defaultConfig =
  basePath: path.join config.baseDir, 'data'

_cache = {}
loadYAMLCache = (name) ->
  stat = fs.statSync name
  time = stat.mtime.getTime()
  entry = _cache[name]
  if entry?.time is time
    return entry.obj
  else
    entry =
      obj: YAML.parse fs.readFileSync name
      time: time

    _cache[name] = entry
    return entry.obj

class Data
  constructor: (options={}) ->
    @options = _.defaults options,defaultConfig

    app = express()
    app.use (req,resp,next) ->
      resp.sendSlice = (array) ->
        if _.isArray(array) and (req.query.start or req.query.count)
          count = parseInt req.query.count or 10
          start = parseInt req.query.start or 0
          array = array.slice start, start + count
        @json array
      next()

    app.get '/', (req, resp) =>
      resp.sendSlice @load 'index.json'

    app.get '/video', (req, resp) =>
      resp.sendSlice @load 'video.json'

    app.get /^\/(\w+\/\w+)\/?$/, (req,resp) =>
      p = Product.loadProduct req.params[0]
      resp.send p

    app.use express.static @options.basePath, {redirect:false}
    return app


  @realFilename = (fn) ->
    path.join @options.basePath, fn

  @load = (name) ->
    try
      loadYAMLCache @realFilename name
    catch
      try
        fs.openSync(@realFilename(name), 'w') if _error.errno is 34
      catch
        console.info 'can not create file'
      console.info _error
      undefined

  @writeJSON = (name,obj) ->
    buf = JSON.stringify obj,false,'  '
    console.info buf
    fs.writeFileSync @realFilename(name), buf

module.exports = Data.bind(Data)
module.exports.__proto__ = Data
