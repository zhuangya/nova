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

defaultConfig =
  basePath: path.join config.baseDir, 'data'

module.exports = (options) ->
  options or= {}
  options = _.defaults options,defaultConfig

  realFilename = (fn) ->
    path.join options.basePath, fn

  metaFilename = (name) ->
    path.join name, "metadata.yml"

  app = express()
  app.use (req,resp,next) ->
    return next() unless req.accepts('json')
    q = req._parsedUrl or url.parse req.url
    sourceFn = metaFilename realFilename decodeURI q.pathname
    if fs.existsSync sourceFn
      content = fs.readFileSync sourceFn
      obj = YAML.parse content
      resp.json obj
    else
      next()

  app.get '/', (req,resp) ->
    console.info req.param
    resp.json loadYAMLCache realFilename 'index.json'

  app.use express.static options.basePath, {redirect:false}
  return app


_cache = {}
loadYAMLCache = (name) ->
  console.info name
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

