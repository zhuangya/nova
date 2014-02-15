passport = require 'passport'
Twitter = (require 'passport-twitter').Strategy
Google  = (require 'passport-google-oauth').OAuth2Strategy
Facebook = (require 'passport-facebook').Strategy
Weibo = (require 'passport-weibo-2').Strategy
LocalStrategy = require('passport-local').Strategy
fibrous = require 'fibrous'

{auth,hostname} = (require '../config')

{User,OAuthProfile} = require './model'

#mailer = require './mailer'

{forEach} = require './utils'

conf = auth

TOKEN_TTL = 3600 * 24 * 30

passport.serializeUser (profile, done) ->
  return done(null,null) if not profile
  done(null,profile._id)

passport.deserializeUser (id, done) ->
  return done(null,null) if not id
  if id.substr(0,5) is 'local'
    done null,{_id:id, _user: id.substr(6), provider: 'local'}
  else
    OAuthProfile.findById(id,done)

passport.use new Weibo
  clientID: conf.weibo.key
  clientSecret: conf.weibo.secret
  callbackURL: "/auth/weibo/callback"
  ,(req,token, secret, profile, done) ->
    profile.token =
      token: token
      secret: secret
    OAuthProfile.createOrUpdate profile,done

###
passport.use new Twitter
  consumerKey: conf.twitter.key
  consumerSecret: conf.twitter.secret
  callbackURL: "/auth/twitter/callback"
  ,(req,token, secret, profile, done) ->
    profile.token =
      token: token
      secret: secret
    OAuthProfile.createOrUpdate profile,done
    
passport.use new Google
  clientID: conf.google.key
  clientSecret: conf.google.secret
  callbackURL: "/auth/google/callback"
  scope: ['https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/userinfo.email']
  ,(req,token, secret, profile, done) ->
    profile.token =
      token: token
      secret: secret
    OAuthProfile.createOrUpdate profile,done

passport.use new Facebook
  clientID: conf.facebook.key
  clientSecret: conf.facebook.secret
  callbackURL: "/auth/facebook/callback"
  scope: ['email']
  ,(req,token, secret, profile, done) ->
    profile.token =
      token: token
      secret: secret
    OAuthProfile.createOrUpdate profile,done
###
passport.use new LocalStrategy
  usernameField: 'email'
  passwordField: 'password'
  ,(username,password,done) ->
    #password = User.hashPasswd password
    User.findByEmail username, (err,obj) ->
      return done(err, false) if err
      return done(null, false, "No such user") unless obj
      return done(null, false, "Bad password") unless password == obj.password
      return done(null, {_id:"local/#{obj._id}", _user: obj._id, provider: 'local'})


checkUserFlag = (flag) ->
  return (req,resp,next) ->
    if req.user
      if not flag or 0 <= req.user.flags.indexOf flag
        next()
      else
        resp.send 403,"Permission denied"
    else
      resp.send 403,"You need to login to view this url"

auth = (app)->
  app.use passport.initialize(userProperty:'oauthProfile')
  app.use passport.session()

  app.use (req,res,_next) ->

    next = (err)->
      if !err and req.user and !req.cookies.token
        res.cookie 'token', req.user.genToken(TOKEN_TTL), maxAge: TOKEN_TTL

      _next err

    loadFromDb = ->
      uid = req.headers['x-userid'] or req.session.user
      return loadFromOauth() unless uid
      User.findById uid, (err,obj) ->
        return next(err) if err
        if obj
          req.user = obj
          next()
        else
          delete req.session.user
          loadFromOauth()

    loadFromOauth = ->
      return loadFromCookie() unless req.oauthProfile?._user
      User.findById req.oauthProfile._user, (err,obj)->
        return next(err) if err
        return loadFromCookie() unless obj
        req.user = obj
        req.session.user = obj._id
        next()
 
    loadFromCookie = ->
      token = req.cookies.token
      return next() unless token
      User.verifyToken token, (err,obj)->
        return next(err) if err
        return next() if not obj
        req.user = obj
        req.session.user = obj._id
        next()

    loadFromDb()

  saveURL = (req,resp,next) ->
    req.session._url = req.query.url if req.query.url
    next()

  ###
  #Twitter
  app.get '/auth/twitter', saveURL, passport.authenticate 'twitter'
  app.get '/auth/twitter/callback', passport.authenticate 'twitter',
    successRedirect: '/auth/checkProfile'
    failureRedirect: '/login'
    passReqToCallback: true

  #Google
  app.get '/auth/google', saveURL, passport.authenticate 'google'
  app.get '/auth/google/callback', passport.authenticate 'google',
    successRedirect: '/auth/checkProfile'
    failureRedirect: '/login'
    passReqToCallback: true

  #Facebook
  app.get '/auth/facebook', saveURL, passport.authenticate 'facebook'
  app.get '/auth/facebook/callback', passport.authenticate 'facebook',
    successRedirect: '/auth/checkProfile'
    failureRedirect: '/login'
    passReqToCallback: true
  ###
  app.get '/auth/weibo', saveURL, passport.authenticate 'weibo'
  app.get '/auth/weibo/callback', passport.authenticate 'weibo',
    successRedirect: '/auth/checkProfile'
    failureRedirect: '/login'
    passReqToCallback: true

  app.get  '/auth/checkProfile', fibrous.middleware, (req,resp) ->
    #console.info req.user
    if not req.oauthProfile
      return resp.redirect '/login'

    done = ->
      url = req.session._url || '/'
      req.session._url = null
      resp.redirect url

    if req.user
      #add oauth asscoation
      uid = req.oauthProfile._user
      if not uid
        req.user.alias = req.oauthProfile.id
        req.user.profile = req.oauthProfile._id
        req.user.sync.save()

        req.oauthProfile._user = req.user._id
        req.oauthProfile.save()

        done()

      else if uid.equals req.user._id
        #Normal login
        done()
      else
        resp.send 500,'OAuth account already used'

    else #not registered
      #resp.redirect '/register'
      user = new User
        name: req.oauthProfile.name
        alias: req.oauthProfile.id
        profile: req.oauthProfile._id
      user.sync.save()
      
      req.oauthProfile._user = user._id
      req.oauthProfile.sync.save()
      req.session.user = user._id

      done()

  app.get '/login', (req,resp) ->
    if req.user
      return resp.redirect '/'
    resp.render 'login'
  
  app.post '/login', fibrous.middleware, (req,resp,next) ->
    (passport.authenticate 'local', (err,user,info) ->
      #console.info arguments
      if user
        req.account = user
        req.sync.logIn user,{}
        resp.redirect req.query.url || '/'
      else
        req.info = info
        return resp.render 'login'
    )(req,resp,next)

  app.get '/register', (req,resp) ->
    if req.user
      return resp.redirect '/'
    resp.render 'register',
      profile: req.oauthProfile
      error: null


  checkRegisterField = (field,value,cb) ->
    return cb {err:"#{field} could not be empty",field: field} unless value

    if field == 'email'
      return cb {err:"Invalid email address!",field: field} unless ///
             [a-z0-9!\#$%&'*+/=?^_`{|}~-]+
        (?:\.[a-z0-9!\#$%&'*+/=?^_`{|}~-]+)*
        @
        (?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+
           [a-z0-9](?:[a-z0-9-]*[a-z0-9])?
      ///.test value

    switch field
      when 'email' then fn = User.findByEmail
      when 'name'  then fn = User.findByName
      else return cb null

    fn = fn.bind User
    fn value, (err,arr) ->
      return cb {err: err, field: field} if err
      return cb {err:"#{field} already in use",field: field} if arr
      return cb null

  checkRegisterFields = (body,cb) ->
    keys = Object.keys body
    f = forEach keys, (key,next) ->
      checkRegisterField key, body[key], next

    f cb

  app.post '/register/check', (req,resp) ->
    checkRegisterFields req.body, (err) ->
      resp.send err or {ok:1}

  app.post '/register', saveURL, (req,resp) ->
    checkRegisterFields req.body, (err) ->
      if err
        resp.render 'register',
          profile: req.body
          error  : err.err
      else
        user = new User req.body
        if req.oauthProfile and req.oauthProfile.provider isnt 'local'
          user.alias = req.oauthProfile.id

        user.save (err,obj)->
          if err
            resp.render 'register',
              profile: req.body
              error  : err.message
          else if not req.oauthProfile \
                   or req.oauthProfile.provider == 'local'
            req.session.user = obj._id
            resp.redirect '/auth/verify_email'
          else
            req.oauthProfile._user = obj._id
            req.oauthProfile.save (err)->
              if err
                resp.send 500,err
              else
                resp.redirect '/auth/verify_email'


#  app.get '/auth', (req,resp) ->
#    resp.render 'login',authorize: true

  #todo: logout url should be sceured with csrf key
  app.get '/auth/logout', (req, resp) ->
    req.logout()
    delete req.session.user
    req.session.regenerate ->
      resp.clearCookie 'token'
      resp.redirect '/'

  #todo: add and check verify code
  app.get '/auth/reset_password', (req,resp) ->
    resp.render 'reset_password', {sysmsg:null, showForm:true}

  app.post '/auth/reset_password', (req,resp) ->
    email = req.body.email
    User.findByEmail email, (err,obj) ->
      return resp.send 500,err if err
      if obj
        obj.sendRstPwdEmail()
        msg = "please check your email for instructions"
        showForm = false
      else
        msg = "email not registered: #{email}"
        showForm = true
      resp.render 'reset_password',
        sysmsg: msg
        showForm: showForm

  app.get '/auth/reset_password/:email/:token', (req,resp) ->
    email = (new Buffer req.params.email, 'base64').toString()
    resp.render 'reset_password_form',
      sysmsg: null
      email: email

  app.post '/auth/reset_password/:email/:token', (req,resp) ->
    email = (new Buffer req.params.email, 'base64').toString()
    showerr = (e) -> resp.render 'reset_password_form', {sysmsg:e, email:email}
    unless req.body.password == req.body.password_verify
      return showerr "Password mismatch"

    token = req.params.token
    password = req.body.password
    User.findByEmail email, (err,obj) ->
      return resp.send 500,err if err
      return showerr "User not found" unless obj
      try
        obj.verifyToken token
      catch e
        #console.info e
        return showerr "Bad Token: " + e.message
      obj.password = password
      obj.save (err) ->
        return showerr "DB Error:" + err.message if err
        resp.render 'reset_password_finish'
            
  app.get '/auth/verify_email', (req,resp) ->
    return resp.redirect '/' unless req.user
    return resp.redirect '/' if 'email_verified' in req.user.flags
    #console.info req.session
    req.user.sendVerifyEmail(req.session._url)
    resp.render 'verify_email'

  app.get '/auth/verify_email/:email/:token', (req,resp) ->
    email = (new Buffer req.params.email, 'base64').toString()
    token = req.params.token
    User.findByEmail email, (err,obj) ->
      return resp.send 500,err if err
      return resp.send 404,"User not found" unless obj
      try
        obj.verifyToken token
      catch e
        console.info e
        return resp.send 403,e.message

      obj.flags.push 'email_verified' unless 'email_verified' in obj.flags
      req.session.user = obj._id
      obj.save (err) ->
        resp.redirect "/welcome" +
          (if req.query.url then "?url=#{encodeURIComponent(req.query.url)}" else "")

auth.checkUserFlag = checkUserFlag
module.exports = auth
