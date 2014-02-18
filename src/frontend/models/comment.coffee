mongoose = require("mongoose")

schema = mongoose.Schema(
  content: String
  post:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Post'
  user:
    type: mongoose.Schema.Types.ObjectId
    ref: 'User'
)


schema.virtual('contentFormatted').get ->
    marked = require 'marked'

    return marked(this.content)

module.exports = mongoose.model("Comment", schema)
