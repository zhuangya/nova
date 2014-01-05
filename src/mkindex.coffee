program = require 'commander'
lazy = require 'lazy.js'
fibrous = require 'fibrous'
_ = require 'underscore'

Product = require './product'

parseName = (name) ->
  (/data\/(\w+\/\w+)\/metadata\.yml/.exec(name))?[1]

notNull = (x) -> !!x

loadData = (name) ->
  product = Product.loadProduct(name)
  #console.info product
  product.validate(name)
  #console.info product
  product.toCachedObject()
  #product

readline = require('readline')

waits = []
result = []

rl = readline.createInterface
  input: process.stdin,
  output: process.stdout,
  terminal: false

rl.on 'line', (line) ->
  waits.push fibrous.run ->
    name = parseName line
    return unless notNull name
    #console.warn "Processing #{name} ..."
    try
      data = loadData name
      result.push
        id: name
        status: "OK"
      return data
    catch
      result.push
        id: name
        error: _error
      return null


rl.on 'close', ->
  fibrous.run ->
    data = fibrous.wait waits
    data = _.filter data, notNull
    console.info JSON.stringify data,false,'  '
    console.warn JSON.stringify result,false,'  '
