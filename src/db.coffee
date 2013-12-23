mongoose = require 'mongoose'
config   = require '../config'

mongoose.connect config.db

module.exports =
  mongoose: mongoose
