program = require 'commander'
lazy = require 'lazy.js'
fibrous = require 'fibrous'

Product = require './product'

parseName = (name) ->
  (/data\/(\w+\/\w+)\/metadata\.yml/.exec(name))?[1]

notNull = (x) -> !!x

loadData = (name) ->
  product = Product.loadProduct(name)
  product.validate()
  #console.info product
  product.toCachedObject()
  #product

readline = require('readline')

waits = []

rl = readline.createInterface
  input: process.stdin,
  output: process.stdout,
  terminal: false

rl.on 'line', (line) ->
  waits.push fibrous.run ->
    name = parseName line
    return unless notNull name
    console.warn "Processing #{name} ..."
    x = loadData name
    x.validate(name)
    x.toCachedObject()

rl.on 'close', ->
  fibrous.run ->
    data = fibrous.wait waits
    console.info JSON.stringify data,false,'  '