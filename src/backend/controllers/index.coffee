Post = require '../../frontend/models/post'
Category = require '../../frontend/models/category'
Content = require '../../frontend/models/content'
User = require '../../auth/models/user'

module.exports =
  dashboard: (req, res) ->
    res.render "dashboard"
    return

  contents:
    index: (req, res) ->
      Content.find {}, (err, contents) ->
        res.render 'contents/index',
          contents: contents

    destroy: (req, res) ->
      Content.remove
        _id: req.params.id
      , (err, docs) ->
        res.redirect "/admin/contents"

      return

    update: (req, res) ->
      Content.findOne
        _id: req.params.id
      , (err, content) ->
        form = require '../forms/create-content'

        form.handle req.body,
          success: (form) ->
            Content.update
              _id: req.params.id
            , req.body, (err, result) ->

          error: (err) ->
            console.warn err

        res.render 'contents/edit',
          form: form.toHTML()
          content: content

    edit: (req, res) ->
      Content.findOne
        _id: req.params.id
      , (err, content) ->
        form = require '../forms/create-content'
        form.bind content

        res.render 'contents/edit',
          form: form.toHTML()
          content: content

    post: (req, res) ->
      form = require '../forms/create-content'

      form.handle req.body,
        success: (form) ->
          slug = require 'slug'
          c = new Content req.body
          c.slug = slug(req.body.title).toLowerCase()
          c.save (err, insert) ->
          res.redirect "/admin/contents"

        error: (form) ->

      res.render 'contents/create',
        form: form.toHTML()

    create: (req, res) ->
      form = require('../forms/create-content')

      res.render 'contents/create',
        form: form.toHTML()

  posts:
    index: (req, res) ->
      Post.find {}, {},
        sort:
            createdAt: -1
      .populate 'category'
      .exec (err, posts) ->
        res.render "posts/index",
          posts: posts

      return

    show: (req, res) ->
      Post.findOne
          _id: req.params.id, (err, post) ->
            marked = require("marked")
            if post.intro
              post.markedIntro = marked(post.intro)
            if post.content
              post.markedContent = marked(post.content)
            res.render "posts/show",
              post: post

      return

    create: (req, res) ->
      Category.find {}, (err, categories) ->
        res.render "posts/new",
          errors: []
          categories: categories
          post: {}

        return

      return

    edit: (req, res) ->
      Category.find (err, categories) ->
        Post.findOne
          _id: req.params.id
        , (err, post) ->
            res.render "posts/edit",
              post: post
              errors: []
              categories: categories

      return

    post: (req, res) ->
      req.checkBody("title", "Tytuł nie może być pusty").notEmpty()
      req.checkBody("intro", "Zajawka artykułu nie może być pusta").notEmpty()
      req.checkBody("content", "Treść artykułu nie może być pusta").notEmpty()
      req.checkBody("category", "Kategoria nie może być pusta").notEmpty()
      Category.find (err, categories) ->
        errors = req.validationErrors(true)
        if errors
          return res.render("posts/new",
            errors: errors
            categories: categories
            post: req.body
          )

        slug = require 'slug'
        req.body.slug = slug(req.body.title).toLowerCase()
        req.body.tags = req.body.tags.split(',')

        post = new Post(req.body)
        post.save (err, post) ->
          res.redirect "/admin/posts"

        return

      return

    update: (req, res) ->
      req.checkBody("title", "Tytuł nie może być pusty").notEmpty()
      req.checkBody("intro", "Zajawka artykułu nie może być pusta").notEmpty()
      req.checkBody("content", "Treść artykułu nie może być pusta").notEmpty()
      req.checkBody("category", "Kategoria nie może być pusta").notEmpty()
      Category.find (err, categories) ->
        errors = req.validationErrors(true)
        if errors
          post = req.body
          post._id = req.params.id
          return res.render("posts/edit",
            errors: errors
            categories: categories
            post: post
          )
        slug = require 'slug'
        req.body.slug = slug(req.body.title).toLowerCase()
        req.body.tags = req.body.tags.split(',')

        Post.update
          _id: req.params.id
        ,
          req.body
        , (err, docs) ->
          res.redirect "/admin/posts"
          return

        return

      return

    destroy: (req, res) ->
      Post.remove
        _id: req.params.id
      , (err, docs) ->
        res.redirect "/admin/posts"
        return

      return

    activate: (req, res) ->
      Post.update
        _id: req.params.id
      ,
        active: true
      , (err, docs) ->
        res.redirect "/admin/posts"
        return

      return

  users:
    index: (req, res) ->
      User.find {}, (err, users) ->
        res.render 'users/index',
          users: users

  categories:
    index: (req, res) ->
      Category.find {}, (err, categories) ->
        res.render "categories/index",
          categories: categories

      return

    create: (req, res) ->
      res.render "categories/new",
        errors: []
        category: {}

      return

    post: (req, res) ->
      req.checkBody("name", "Nazwa kategorii nie może być pusta.").notEmpty()
      errors = req.validationErrors(true)
      if errors
        return res.render("categories/new",
          errors: errors
          category: {}
        )
      slug = require("slug")
      req.body.slug = slug(req.body.name).toLowerCase()
      category = new Category req.body
      category.save (err, docs) ->
        res.redirect "/admin/categories"
        return

      return

    destroy: (req, res) ->
      Category.remove
        _id: req.params.id
      , (err, docs) ->
        req.flash('notice', 'Usunięto')
        res.redirect "/admin/categories"
        return

      return
