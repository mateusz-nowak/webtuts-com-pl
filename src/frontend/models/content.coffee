Category = require './category'
mongoose = require 'mongoose'
moment = require 'moment'
marked = require 'marked'

schema = mongoose.Schema(
  title:
    type: String
    default: ''
  slug:
    type: String
  content:
    type: String
    default: ''
  createdAt:
    type: Date
    default: Date.now
)

schema.virtual('contentFormatted').get ->
  return marked(this.content)

schema.virtual('createdAtFormatted').get ->
  return moment(this.createdAt).format 'YYYY/MM/D h:mm:ss'

module.exports = mongoose.model("Content", schema)

