module.exports =
  dashboard: (req, res) ->
    res.render "dashboard"
    return

  posts:
    index: (req, res) ->
      req.mongo.collection("posts").find {}, (err, cursor) ->
        join = new mongoJoin(req.mongo).on(
          field: "category"
          to: "_id"
          from: "categories"
        ).toArray(cursor, (errr, posts) ->
          res.render "posts/index",
            posts: posts

          return
        )
        return

      return

    show: (req, res) ->
      new mongoJoin(req.mongo).on(
        field: "category"
        to: "_id"
        from: "categories"
      ).findOne req.mongo.collection("posts"),
        _id: new ObjectID(req.params.id)
      , [], (err, post) ->
        marked = require("marked")
        post.markedIntro = marked(post.intro)
        post.markedContent = marked(post.content)
        res.render "posts/show",
          post: post

        return

      return

    create: (req, res) ->
      req.mongo.collection("categories").find({}).toArray (err, categories) ->
        res.render "posts/new",
          errors: []
          categories: categories
          post: {}

        return

      return

    edit: (req, res) ->
      req.mongo.collection("categories").find({}).toArray (err, categories) ->
        req.mongo.collection("posts").find
          _id: new ObjectID(req.params.id)
        , (err, post) ->
          post.next (err, post) ->
            res.render "posts/edit",
              post: post
              errors: []
              categories: categories

            return

          return

        return

      return

    post: (req, res) ->
      req.checkBody("title", "Tytuł nie może być pusty").notEmpty()
      req.checkBody("intro", "Zajawka artykułu nie może być pusta").notEmpty()
      req.checkBody("content", "Treść artykułu nie może być pusta").notEmpty()
      req.checkBody("category", "Kategoria nie może być pusta").notEmpty()
      req.mongo.collection("categories").find({}).toArray (err, categories) ->
        errors = req.validationErrors(true)
        if errors
          return res.render("posts/new",
            errors: errors
            categories: categories
            post: req.body
          )
        req.mongo.collection("posts").insert req.body, (err, docs) ->
          res.redirect "/admin/posts"
          return

        return

      return

    update: (req, res) ->
      req.checkBody("title", "Tytuł nie może być pusty").notEmpty()
      req.checkBody("intro", "Zajawka artykułu nie może być pusta").notEmpty()
      req.checkBody("content", "Treść artykułu nie może być pusta").notEmpty()
      req.checkBody("category", "Kategoria nie może być pusta").notEmpty()
      req.mongo.collection("categories").find({}).toArray (err, categories) ->
        errors = req.validationErrors(true)
        if errors
          post = req.body
          post._id = req.params.id
          return res.render("posts/edit",
            errors: errors
            categories: categories
            post: post
          )
        req.mongo.collection("posts").update
          _id: new ObjectID(req.params.id)
        ,
          $set: req.body
        , (err, docs) ->
          res.redirect "/admin/posts"
          return

        return

      return

    destroy: (req, res) ->
      req.mongo.collection("posts").remove
        _id: new ObjectID(req.params.id)
      , (err, docs) ->
        res.redirect "/admin/posts"
        return

      return

    activate: (req, res) ->
      req.mongo.collection("posts").update
        _id: new ObjectID(req.params.id)
      ,
        $set:
          active: true
      , (err, docs) ->
        res.redirect "/admin/posts"
        return

      return

  categories:
    index: (req, res) ->
      req.mongo.collection("categories").find({}).toArray (err, categories) ->
        res.render "categories/index",
          categories: categories

        return

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
      req.mongo.collection("categories").insert req.body, (err, docs) ->
        res.redirect "/admin/categories"
        return

      return

    destroy: (req, res) ->
      req.mongo.collection("categories").remove
        _id: new ObjectID(req.params.id)
      , (err, docs) ->
        res.redirect "/admin/categories"
        return

      return
