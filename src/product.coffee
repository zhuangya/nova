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
    ]

  save: ->
    mkdirp.sync path.dirname Product.getMetadataPath(@id)
    fs.writeFileSync Product.getMetadataPath(@id), @dumpMetadata()

  getPrice: (variant=@_variant,size=@_size) ->
    return @variants[variant].sizes[size].price

  getInventory: (variant=@_variant,size=@_size) ->
    return @variants[variant].sizes[size].inventory

  updateInventory: (count,variant=@_variant,size=@_size) ->
    console.info variant
    return @variants[variant].sizes[size].inventory += count

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

    throw new Error "Id mismatch: '#{@id}', should be '#{id}'" unless id is @id
    throw new Error "Missing name field: #{@id}"       unless @name
    throw new Error "Missing desciption field: #{@id}" unless @description
    throw new Error "Missing variants field: #{@id}"   unless @variants instanceof Object
    for k,v of @variants
      #throw "Variant name mismatch: #{@id}/#{k}" unless v.name is k
      throw new Error "Missing screen_name field: #{@id}/#{k}" unless v.screen_name
      throw new Error "Missing sizes field: #{@id}/#{k}" unless v.sizes instanceof Object
      for sk,sv of v.sizes
        #throw "size name mismatch: #{@id}/#{k}/#{sv}" unless sv.name is sk
        throw new Error "Missing price field: #{@id}/#{k}/#{sv}" unless typeof sv.price is 'number'
        throw new Error "Missing inventory field: #{@id}/#{k}/#{sv}" unless typeof sv.inventory is 'number'

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

  toJSON: ->
    obj = _.pick(this,['id', 'name', 'description'])
    #console.warn (new Error).stack
    #console.warn @variants
    obj.variants = _.map(@variants,(v,k) ->
      nv = _.clone v
      nv.name = k
      nv.sizes = _.map(v.sizes, (s,k)->
        ns = _.clone s
        ns.name = k
        return ns
      )
      return nv
    )
    return obj

  toObject: ->
    obj = @toJSON()
    cover_name = @getImagePath 'cover.jpg'
    cover_info = @sync._getImageSize @getPath cover_name
    main_name  = @getImagePath 'main.jpg'
    main_info  = @sync._getImageSize @getPath main_name
    obj.cover_name = cover_name
    obj.cover_size =
      width: cover_info.width
      height: cover_info.height
    obj.main_name = main_name
    obj.main_size =
      width: main_info.width
      height: main_info.height

    return obj

  toCachedObject: ->
    @toObject()

module.exports = Product
