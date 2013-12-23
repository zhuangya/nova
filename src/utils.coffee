crypto = require 'crypto'

#async foreach iterator, call fn on each object in arr
#fn must accept signature (obj,next) where next is a function
#should be called before fn returns.
#call next(error) when you want to stop the iteration
#return a function that accepts a callback to recvice notice
#when the iteration is done
@forEach = (arr,fn) ->
  (cb) ->
    return cb(null,null) unless arr
    #console.info arr.length
    step = (i,err) ->
      #console.info arguments
      return cb(err,arr) if err
      if i < arr.length
        fn arr[i],step.bind(null,i + 1)
      else
        cb(null,arr)
    step(0)

now = @now = -> (new Date).valueOf()

genHash = @genHash = (string,salt = 'SaLtSecRet') ->
  crypto.createHmac('sha1',salt).update(string).digest('hex')

@genToken = (fn, salt = 'SaLtSecRet') ->
  (expires) ->
    expires or= 0
    expires *= 1000
    expires += now() if expires
    extra = fn.call this
    str = "#{expires}.#{extra}"
    hash = genHash str,salt
    "#{str}.#{hash}"

@verifyToken = (fn, salt = 'SaLtSecRet') ->
  (token, time) ->
    m = token.split '.'
    throw new Error 'bad token format' unless m.length == 3
    [expires, extra, hash1] = m
    str = "#{expires}.#{extra}"
    hash = genHash str, salt
    throw new Error 'hash mismatch' unless hash == hash1
    time = now() if time is undefined
    console.info expires,time
    throw new Error 'token expired' if expires < time
    fn.call this,extra

