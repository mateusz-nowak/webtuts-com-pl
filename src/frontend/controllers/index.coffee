mongoose = require 'mongoose'
paginate = require('mongoose-pager')(mongoose)

Post = require '../models/post'

PER_PAGE = 2

module.exports.index = (req, res) ->
  Post
    .find {}
    .paginate parseInt(req.params.page || 1), PER_PAGE, (err, posts, total) ->
      res.render "index",
        posts: posts

  return

module.exports.create = (req, res) ->
  res.render "create"
  return
