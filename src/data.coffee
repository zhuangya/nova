express = require 'express'
_ = require 'underscore'
im = require 'imagemagick'
fs = require 'fs'
url = require 'url'
path = require 'path'
events = require 'events'
mkdirp = require 'mkdirp'
yaml = require 'js-yaml'

defaultConfig =
  basePath: './data'

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
    sourceFn = realFilename decodeURI q.pathname
    stat = fs.statSync sourceFn
    if stat.isDirectory()
      sourceFn = metaFilename sourceFn
      #console.info sourceFn
      content = fs.readFileSync sourceFn
      obj = yaml.safeLoad content.toString()
      resp.json obj
    else
      next()

  app.use express.static options.basePath, {redirect:false, index:"metadata.yml"}
  return app
