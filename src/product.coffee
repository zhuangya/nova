fs = require 'fs'
yaml = require 'js-yaml'
path = require 'path'
image = require 'imagemagick'
fibrous = require 'fibrous'
_ = require 'underscore'

config = require '../config'

class Product
  @getMetadataPath: (id) ->
    path.join config.baseDir, 'data', id, 'metadata.yml'

  @loadMetadata: (id) ->
    content = fs.readFileSync(@getMetadataPath(id))
    yaml.safeLoad content.toString()
  
  @loadProduct: (id) ->
    obj = @loadMetadata(id)
    #obj.constructor = this
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

  getPath: (x) ->
    path.join config.baseDir, 'data', @id, x

  getImagePath: (name) ->
    #1. see if name exists
    p = name
    return p if fs.existsSync @getPath p

    #2. add prefix of first variant name
    variant_name = Object.keys(@variants).shift()
    p = variant_name + "_" + name
    return p if fs.existsSync @getPath p

    #nothing? throw
    throw "Image not found for #{@id}: #{name}"

  validate: (id=@id) ->
    
    throw "Id mismatch: '#{@id}', should be '#{id}'" unless id is @id
    
    throw "Missing name field: #{id}"       unless @name
    throw "Missing desciption field: #{id}" unless @description
    throw "Missing variants field: #{id}"   unless @variants instanceof Object
    throw "Missing price field: #{id}"      unless typeof @price is 'number' or @price instanceof Object

    @getImagePath 'cover.jpg'
    @getImagePath 'main.jpg'

    true

  toCachedObject: ->
    name =  @getImagePath 'cover.jpg'
    info = image.sync.identify @getPath name
    @cover_name = name
    @cover_size =
      width: info.width
      height: info.height
    _.omit this,'inventory'

module.exports = Product
