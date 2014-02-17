mongoose = require 'mongoose'
paginate = require('mongoose-pager')(mongoose)

Content = require '../models/content'
Category = require '../models/category'
Post = require '../models/post'
Comment = require '../models/comment'

PER_PAGE = 10

module.exports.post = {}
module.exports.post.show = (req, res) ->
  Post.findOne
      slug: req.params.slug
    .populate 'comments'
    .exec (err, post) ->
      formComment = require '../forms/post-comment'

      if req.method == 'POST'
        formComment.handle req.body,
          success: (form) ->
            commentData = req.body
            commentData.user = res.locals.user

            comment = new Comment commentData
            comment.save  (err, insert) ->
                req.flash 'notice', 'Twój komentarz został dodany'

                post.comments.push(insert)
                post.save (err, updt) ->
                  res.redirect '/post/' + post.slug + '#comments'

          error: (form) ->

      res.render 'posts/show',
        post: post
        formComment: formComment

module.exports.index = (req, res) ->
  page = parseInt(req.query.page || 1)

  Post
    .find {}
    .paginate page, PER_PAGE, (err, posts, total) ->
      pagination = require 'pagination'

      res.render 'index',
        pager: pagination.create 'search',
          prelink: '/'
          current: page
          rowsPerPage: PER_PAGE
          totalResult: total
        posts: posts

module.exports.category = (req, res) ->
  page = parseInt(req.query.page || 1)

  Category.findOne
    slug: req.params.category, (err, category) ->
      Post
        .find
          category: category.id
        .populate 'category'
        .paginate page, PER_PAGE, (err, posts, total) ->
          pagination = require 'pagination'

          res.render 'index',
            pager: pagination.create 'search',
              prelink: '/'
              current: page
              rowsPerPage: PER_PAGE
              totalResult: total
            posts: posts

module.exports.search = (req, res) ->
  page = parseInt(req.query.page || 1)
  query = req.query.s

  Post
    .find
      $or: [
        { title: new RegExp(query) },
        { intro: new RegExp(query) },
        { body: new RegExp(query) },
        { tags: new RegExp(query) }
      ]
    .paginate page, PER_PAGE, (err, posts, total) ->
      pagination = require 'pagination'

      res.render 'search',
        pager: pagination.create 'search',
          prelink: '/'
          current: page
          rowsPerPage: PER_PAGE
          totalResult: total
        posts: posts

module.exports.create = (req, res) ->
  res.render "create"

module.exports.contents = {}
module.exports.contents.show = (req, res) ->
  Content.findOne
    slug: req.params.slug, (err, content) ->
      res.render 'contents/show',
        content: content

module.exports.notFound = (req, res) ->
  res.render '404'
