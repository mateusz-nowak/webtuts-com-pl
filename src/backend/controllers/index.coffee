Category = require('../../frontend/models/category')
Post = require('../../frontend/models/post')

module.exports =
  dashboard: (req, res) ->
    res.render "dashboard"
    return

  posts:
    index: (req, res) ->
      Post.find {}, {},
        sort:
            createdAt: -1
      ,(err, posts) ->
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
