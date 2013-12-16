fs = require 'fs'
yaml = require 'js-yaml'
path = require 'path'

class Product
  @getMetadataPath: (id) ->
    path.join './data', id, 'metadata.yml'

  @loadMetadata: (id) ->
    content = fs.readFileSync(@getMetadataPath(id))
    yaml.safeLoad content.toString()
  
  @loadProduct: (id) ->
    obj = @loadMetadata(id)
    obj.constructor = this
    obj.__proto__ = @prototype
    return obj

  @loadItem: (name) ->
    match = /(\w+\/\w+)\/(\w+)\/(\w+)/.exec name
    throw message:"malformed item name", code:400 unless match
    id = match[1]
    variant = match[2]
    size = match[3]
    obj = @loadProduct id
    throw message:"product not found", code:404 unless obj
    obj.variant = variant
    obj.size = size
    return obj

  dumpMetadata: ->
    yaml.dump this

  save: ->
    fs.writeFileSync getMetadataPath(@id), @dumpMetadata()

  getPrice: (variant=@variant) ->
    return @price if typeof @price is 'number'
    return @price[variant]

module.exports = Product
