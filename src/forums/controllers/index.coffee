route = module.exports = {}

Thread = require '../models/thread'
Post = require '../models/post'

PER_PAGE = 20

route.index = (req, res) ->
  page = parseInt(req.query.page || 1)

  Thread.find {}, {},
    sort:
      createdAt: -1
  .populate 'user'
  .paginate page, PER_PAGE, (err, threads, total) ->
    pagination = require 'pagination'

    res.render 'threads/index',
      threads: threads
      pager: pagination.create 'search',
        prelink: '/forum'
        current: page
        rowsPerPage: PER_PAGE
        totalResult: total

route.create = (req, res) ->
  form = require '../forms/thread'

  res.render 'threads/new',
    form: form

route.remove = (req, res) ->
  Thread.remove
    _id: req.params.thread
  , (err, thread) ->
    req.flash 'notice', 'Usunięto wątek'

    res.redirect 'back'

route.show = (req, res) ->
  Thread.findOne
    _id: req.params.id
   , (err, thread) ->
     return res.redirect '/not-exists' if !thread

     Post.find
      thread: req.params.id, {}, sort:
        createdAt: 1
     .populate 'user'
     .exec (err, posts) ->
        res.render 'threads/show',
          thread: thread
          posts: posts

route.post = (req, res) ->
  form = require '../forms/thread'

  form.handle req.body,
    success: (form) ->
      threadData = req.body
      threadData.user = res.locals.user._id

      thread = new Thread threadData
      thread.save (err, thread) ->
        threadData.thread = thread._id

        post = new Post threadData
        post.save (err, post) ->
          req.flash 'notice', 'Poprawnie dodano wątek'
          return res.redirect '/forum'

    error: (form) ->
      res.render 'threads/new',
        form: form

route.posts = {}
route.posts.create = (req, res) ->
  form = require '../forms/post'

  res.render 'posts/new',
    form: form

route.posts.remove = (req, res) ->
  Post.remove
    _id: req.params.post, (err, post) ->
      req.flash 'notice', 'Post został usunięty'

      return res.redirect '/forum/' + req.params.thread

route.posts.post = (req, res) ->
  form = require '../forms/post'

  form.handle req.body,
    success: (form) ->
      post = new Post req.body
      post.user = res.locals.user
      post.thread = req.params.id

      post.save (err, post) ->
        req.flash 'notice', 'Twoja odpowiedź została dodana.'

        return res.redirect '/forum/' + req.params.id
    error: (form) ->
      res.render 'posts/new',
        form: form
