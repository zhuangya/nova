fs = require 'fs'
yaml = require 'js-yaml'
path = require 'path'
image = require 'imagemagick'
fibrous = require 'fibrous'
mkdirp = require 'mkdirp'
_ = require 'underscore'

config = require '../config'

class Product
  @getMetadataPath: (id) =>
    path.join config.baseDir, 'data', id, 'metadata.yml'

  @loadMetadata: (id) =>
    content = fs.readFileSync(@getMetadataPath(id))
    yaml.safeLoad content.toString()

  @loadProduct: (id) =>
    obj = @loadMetadata(id)
    return @(obj)

  @loadItem: (name) =>
    match = /(\w+\/\w+)\/(\w+)\/(\w+)/.exec name
    throw message:"malformed item name", code:400 unless match
    id = match[1]
    variant = match[2]
    size = match[3]
    obj = @loadProduct id
    throw message:"product not found", code:404 unless obj
    obj._variant = variant
    obj._size = size
    return obj

  constructor: (obj) ->
    obj.__proto__ = Product.prototype
    return obj

  dumpMetadata: ->
    yaml.dump _.pick this, [
      'id',
      'name',
      'description',
      'variants',
      'price',
      'inventory',
    ]

  save: ->
    mkdirp.sync path.dirname Product.getMetadataPath(@id)
    fs.writeFileSync Product.getMetadataPath(@id), @dumpMetadata()

  getPrice: (variant=@_variant,size=@_size) ->
    return @price if typeof @price is 'number'
    return @price[size] if typeof @price[size] is 'number'
    return @price[variant] if typeof @price[variant] is 'number'
    return @price[variant][size] || throw "Unable to fetch price of #{@id}/#{variant}/#{size}"

  getInventory: (variant=@_variant,size=@_size) ->
    return @inventory if typeof @inventory is 'number'
    return @inventory[size] if typeof @inventory[size] is 'number'
    return @inventory[variant] if typeof @inventory[variant] is 'number'
    return @inventory[variant][size] || throw "Unable to fetch inventory of #{@id}/#{variant}/#{size}"

  updateInventory: (count,variant=@variant,size=@_size) ->
    if typeof @inventory is 'number'
      @inventory += count
    else if typeof @inventory[size] is 'number'
      @inventory[size] += count
    else if typeof @inventory[variant] is 'number'
      @inventory[variant] += count
    else
      @inventory[variant][size] += count

  getPath: (x) ->
    path.join config.baseDir, 'data', @id, x

  getImagePath: (name) ->
    #1. see if name exists
    p = name
    return p if fs.existsSync @getPath p

    #2. add prefix of first variant name
    if @variants
      variant_name = Object.keys(@variants).shift()
      p = variant_name + "_" + name
      return p if fs.existsSync @getPath p

    #nothing? throw
    throw "Image not found for #{@id}: #{name}"

  validate: (id=@id,with_image=true) ->

    throw "Id mismatch: '#{@id}', should be '#{id}'" unless id is @id
    throw "Missing name field: #{@id}"       unless @name
    throw "Missing desciption field: #{@id}" unless @description
    #throw "Missing variants field: #{@id}"   unless @variants instanceof Object
    throw "Missing price field: #{@id}"      unless typeof @price is 'number' or @price instanceof Object
    #throw "Missing inventory field: #{@id}"  unless typeof @inventory is 'number' or @inventory instanceof Object

    if with_image
      @getImagePath 'cover.jpg'
      @getImagePath 'main.jpg'

    true

  _getImageSize: (path,cb) ->
    image.identify ['-format', '%wx%h', path], (err, str) ->
      if err
        cb err
      else
        str = str.split 'x'
        cb null,
          width: parseInt str[0]
          height: parseInt str[1]

  toObject: ->
    cover_name = @getImagePath 'cover.jpg'
    cover_info = @sync._getImageSize @getPath cover_name
    main_name  = @getImagePath 'main.jpg'
    main_info  = @sync._getImageSize @getPath main_name
    @cover_name = cover_name
    @cover_size =
      width: cover_info.width
      height: cover_info.height
    @main_name = main_name
    @main_size =
      width: main_info.width
      height: main_info.height

    return this

  toCachedObject: ->
    _.omit @toObject(),'inventory'

module.exports = Product
