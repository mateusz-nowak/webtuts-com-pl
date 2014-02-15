Post = require '../models/post'

module.exports.index = (req, res) ->
  Post.find {}, (err, posts) ->
    res.render "index",
      posts: posts
      marked: require 'marked'

  return

module.exports.create = (req, res) ->
  res.render "create"
  return
