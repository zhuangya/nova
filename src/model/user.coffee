db = require 'mongoose'
#gravatar = require 'gravatar'
timestamps = require 'mongoose-timestamp'
utils = require '../utils'
#mailer = require '../mailer'
config = require '../../config'

fibrous = require 'fibrous'

schema = db.Schema
  name: #Display Name
    type: String
    required: true
    unique: true
  email: #email address
    type: String
    required: true
    unique: true
  password:
    type: String
    required: false
  flags:
    type: [String]
    index: true
    spare: true
  alias:
    type: [String]
    index: true
    #unique: true
  points: Number
  descr: String
  _icon_url: String
  counter:
    projects:
      type: Number
      default: 0
    ideas:
      type: Number
      default: 0
    comments:
      type: Number
      default: 0
    likes:
      type: Number
      default: 0

schema.plugin(timestamps)

schema.statics.findByAlias = (id,cb) ->
  @findOne 'alias': id, cb

schema.statics.findByEmail = (email,cb) ->
  @findOne 'email': email, cb

schema.statics.findByName = (name,cb) ->
  @findOne 'name': name, cb

schema.statics.hashPasswd = utils.genHash

schema.statics.updateCounter = fibrous (id,name,val = 1) ->
  console.info "update counter #{name}"
  op = $inc: {}
  op.$inc[name] = val
  @sync.findByIdAndUpdate id, op

schema.virtual('icon_url').get ->
  @_icon_url or gravatar.url @email,
    d:"http://#{config.hostname}/images/avatar11.png"

schema.virtual('is_admin').get ->
  @flags.indexOf 'admin' >= 0

schema.virtual('icon_url_large').get ->
  @_icon_url and @_icon_url + "?schema=profileIcon100" or gravatar.url @email,
    d:"http://#{config.hostname}/images/avatar11.png"
    s:100

schema.methods.genToken = utils.genToken -> @id
schema.methods.verifyToken = utils.verifyToken (id) ->
  throw new Error 'id mismatch' unless id == @id
  return id

schema.statics._verifyToken = utils.verifyToken (id) -> return id
schema.statics.verifyToken = fibrous (token) ->
  try
    @sync.findById @_verifyToken token
  catch e
    console.info e
    null

schema.methods.sendVerifyEmail = (url)->
  token = @genToken 3600 * 24
  email = (new Buffer @email).toString 'base64'
  url = url and "?url=#{encodeURIComponent(url)}" or ""
  mailer.sendMail 'email_verify',
    user: this
    link: "http://#{config.hostname}/auth/verify_email/#{email}/#{token}#{url}"

schema.methods.sendRstPwdEmail = ->
  token = @genToken 3600 * 24
  email = (new Buffer @email).toString 'base64'
  mailer.sendMail 'reset_password',
    user: this
    link: "http://#{config.hostname}/auth/reset_password/#{email}/#{token}"

schema.methods.getLikedIdeas = fibrous (options) ->
  fibrous.wait db.model('ActionLog').sync.find({
    user: @_id
    action: 'fav.create'
  },{
    object:1
  },options).map( (l) ->
    db.model('Idea').future.findById l.object.id
  )

schema.methods.getOwnIdeas = fibrous (options) ->
  db.model('Idea').sync.find(
    ownner: @_id
    class: 'article'
  ,null,options)

schema.methods.isFirstView = fibrous (project) ->
  log = db.model('ActionLog').sync.findOne({
    user: @_id
    action: 'project.view'
    'object.id': project._id
  })
  return false if log
  db.model('ActionLog').sync.write
    user: @_id
    action: 'project.view'
    object: id: project._id
  return true

schema.methods.updateCounter = fibrous (name,val = 1) ->
  op = $inc: {}
  op.$inc[name] = val
  @sync.update op

schema.methods.toJSON = ->
  id: @_id
  name: @name
  #email: @email
  icon_url: @icon_url
  icon_url_large: @icon_url_large
  alias: @alias
  points: @points
  descr: @descr
  counter: @counter
  flags: @flags

module.exports = db.model 'User', schema

