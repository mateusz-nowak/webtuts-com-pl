mongoose = require 'mongoose'

schema = mongoose.Schema(
  name:
    type: String
    default: ''
  slug:
    type: String
    default: ''
)

module.exports = mongoose.model 'JobCategory', schema
