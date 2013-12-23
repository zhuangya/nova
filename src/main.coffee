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
app.set 'view engine', 'jade'
app.set 'view options',
  layout: false

app.use express.favicon()
app.use express.logger 'dev'

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

app.get '/', (req,resp) ->
  resp.render('index')

(require './auth')(app)
app.use '/api', (require './api')()
app.use '/data', (require './data')()
app.use '/photo', (require './photo')()

host = config.httpd.bind or "127.0.0.1"
port = process.env.PORT or config.httpd.port or 3000
console.info "Listening on port #{host}:#{port}"
app.listen port,host

