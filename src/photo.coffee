express = require 'express'
_ = require 'underscore'
im = require 'imagemagick'
fs = require 'fs'
url = require 'url'
path = require 'path'
events = require 'events'
mkdirp = require 'mkdirp'

class ImageProcessor extends events.EventEmitter
  _pending = {}
  @isPending: (fn) ->
    _pending[fn]

  @convert: (dst,src,opts) ->
    return _pending[dst] if _pending[dst]
    _pending[dst] = new ImageProcessor dst,src,opts

  parseOpts: (opts) ->
    _.clone opts

  ensureDir: (dst) ->
    mkdirp.sync path.dirname dst

  constructor: (dst, src, opts) ->
    @ensureDir dst
    opts = @parseOpts opts
    opts.unshift src
    opts.push dst
    im.convert opts, (err,sdtout,stderr) =>
      delete _pending[dst]
      if err
        console.info stderr
        @emit 'error',err
      else
        @emit 'done', dst

defaultConfig =
  basePath: './data'
  cachePath: './cache'
  defaultFormat: 'jpeg'
  schemas:
    "aticleImg214":
      ['-resize', '214']
    "addAnIdeaImg200":
      ['-resize', 'x200']
    "articleDetailImg440x330":
      ['-resize', '440x330']
    "visionBoardImg142":
      ['-resize', '142']
    "visionBoardImg120":
      ['-resize', '120']
    "homeImg280x280":
      ['-resize', '280x280']
    "homeImg470x470":
      ['-resize', '470x470']
    "profileImg160x190":
      ['-resize', '160x190']
    "profileIcon100":
      ['-resize', '100x100']

module.exports = (options) ->
  options or= {}
  options = _.defaults options,defaultConfig
  cache = express.static options.cachePath
  origin = express.static options.basePath

  realFilename = (fn) ->
    path.join options.basePath, fn

  cachedFilename = (fn,schema) ->
    path.join options.cachePath, schema, fn

  cachedUrl = (fn, schema) ->
    path.join '/', schema, fn

  findCachedFile = (fn,opt,cb) ->
    sourceFn = realFilename fn
    return cb 'source file not found: ' + sourceFn unless fs.existsSync sourceFn
    schema = opt.schema
    schemaDef = options.schemas[schema]
    return cb 'schema not defined' unless schemaDef
    destFn = cachedFilename fn, schema
    if (fs.existsSync destFn) and (not ImageProcessor.isPending destFn)
      return cb null, cachedUrl fn,schema
    else
      (ImageProcessor.convert destFn, sourceFn, schemaDef)
      .on 'error', (err) ->
        cb err
      .on 'done', (dst) ->
        cb null, cachedUrl fn,schema

  app = express()
  app.use (req,resp,next) ->
    return origin req,resp,next unless req.query?.schema
    q = req._parsedUrl or url.parse req.url
    findCachedFile (decodeURI q.pathname), req.query, (err,path) ->
      return resp.send 404,err if err
      req.url = path
      cache req,resp,next

  return app
