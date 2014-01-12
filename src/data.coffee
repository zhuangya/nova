express = require 'express'
_ = require 'underscore'
im = require 'imagemagick'
fs = require 'fs'
url = require 'url'
path = require 'path'
events = require 'events'
fibrous = require 'fibrous'
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

      file = @load 'index.json'

      if file
        resp.sendSlice file
      else
        resp.send 404,
          errno: 404
          errmsg: 'Not found'

    app.get '/video', (req, resp) =>
      fileStream = @load 'video.json'
      fileStream = [] unless fileStream
      resp.sendSlice fileStream

    app.get /^\/(\w+\/\w+)\/?$/,fibrous.middleware, (req,resp) =>
      p = Product.loadProduct req.params[0]
      resp.send p.toObject()

    app.use express.static @options.basePath, {redirect:false}
    return app


  @realFilename = (fn) ->
    path.join @options.basePath, fn

  @load = (name) ->
    try
      loadYAMLCache @realFilename name
    catch
      try
        # touch the file if it's not existed, ErrNo 34: no such file or directory
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
