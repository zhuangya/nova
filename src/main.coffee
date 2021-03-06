require('source-map-support').install handleUncaughtExceptions: false
config = require '../config'

#if config.debug
#  require 'node-codein'

path = require 'path'
express = require 'express'
fibrous = require 'fibrous'
cors = require 'cors'

MemcachedStore = require('connect-memcached')(express)

baseDir = config.baseDir = path.normalize __dirname + "/../"

console.info baseDir
templates = baseDir + "/views"
webroot = baseDir + "/webroot"

app = express()

app.enable 'trust proxy'

app.set 'views', templates
app.set 'view engine', 'ejs'
app.set 'view options',
  layout: false

app.use express.favicon("#{__dirname}/../frontend/app/favicon.ico")
app.use express.logger 'dev'
app.use express.errorHandler()

app.use express.static webroot

app.use express.bodyParser
  keepExtensions: true
  uploadDir: baseDir + '/tmp'

app.use express.cookieParser()
app.use express.session
  key: 'session_id'
  secret: config.httpd.session_key or "balabala"
  store : new MemcachedStore
    hosts: config.memcached or '127.0.0.1:11211'

app.use cors()
app.use (req,resp,next) ->
  resp.locals.request = req
  next()

app.locals.config = config

db = require './db'

(require './auth')(app)

app.use '/api', (require './api')()
app.use '/data', (require './data')()
app.use '/photo', (require './photo')()

alipay = require './alipay'
alipay.route app


host = config.httpd.bind or "127.0.0.1"
port = process.env.PORT or config.httpd.port or 3000
console.info "Listening on port #{host}:#{port}"
app.listen port,host

