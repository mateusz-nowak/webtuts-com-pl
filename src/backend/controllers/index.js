var ObjectID = require('mongodb').ObjectID;
var mongoJoin = require('mongo-join').Join;

module.exports = {
    dashboard: function(req, res) {
        res.render('dashboard');
    },

    posts: {
        index: function(req, res) {
            req.mongo.collection('posts').find({}, function(err, cursor) {
                var join = new mongoJoin(req.mongo).on({
                    'field': 'category',
                    'to': '_id',
                    'from': 'categories'
                }).toArray(cursor, function(errr, posts) {
                    res.render('posts/index', {
                        posts: posts
                    });
                });
            });
        },

        show: function(req, res) {
            new mongoJoin(req.mongo).on({
                'field': 'category',
                'to': '_id',
                'from': 'categories'
            }).findOne(req.mongo.collection('posts'), { _id: new ObjectID(req.params.id) }, [], function(err, post) {
                var marked = require('marked');

                post.markedIntro = marked(post.intro);
                post.markedContent = marked(post.content);

                res.render('posts/show', { post: post });
            });
        },

        new: function(req, res) {
            req.mongo.collection('categories').find({}).toArray(function(err, categories) {
                res.render('posts/new', { errors: [], categories: categories, post: {} });
            });
        },

        edit: function(req, res) {
            req.mongo.collection('categories').find({}).toArray(function(err, categories) {
                req.mongo.collection('posts').find({ _id: new ObjectID(req.params.id) }, function(err, post) {
                    post.next(function(err, post) {
                        res.render('posts/edit', { post: post, errors: [], categories: categories });
                    });
                });

            });
        },

        post: function(req, res) {
            req.checkBody('title', 'Tytuł nie może być pusty').notEmpty();
            req.checkBody('intro', 'Zajawka artykułu nie może być pusta').notEmpty();
            req.checkBody('content', 'Treść artykułu nie może być pusta').notEmpty();
            req.checkBody('category', 'Kategoria nie może być pusta').notEmpty();

            req.mongo.collection('categories').find({}).toArray(function(err, categories) {
                var errors = req.validationErrors(true);

                if (errors) {
                    return res.render('posts/new', { errors: errors, categories: categories, post: req.body });
                }

                req.mongo.collection('posts').insert(req.body, function(err, docs) {
                    res.redirect('/admin/posts');
                });
            });
        },

        update: function(req, res) {
            req.checkBody('title', 'Tytuł nie może być pusty').notEmpty();
            req.checkBody('intro', 'Zajawka artykułu nie może być pusta').notEmpty();
            req.checkBody('content', 'Treść artykułu nie może być pusta').notEmpty();
            req.checkBody('category', 'Kategoria nie może być pusta').notEmpty();

            req.mongo.collection('categories').find({}).toArray(function(err, categories) {
                var errors = req.validationErrors(true);

                if (errors) {
                    var post = req.body;
                    post._id = req.params.id;

                    return res.render('posts/edit', { errors: errors, categories: categories, post: post });
                }

                req.mongo.collection('posts').update({ _id: new ObjectID(req.params.id) }, {$set: req.body}, function(err, docs) {
                    res.redirect('/admin/posts');
                });
            });

        },

        delete: function(req, res) {
            req.mongo.collection('posts').remove({ _id: new ObjectID(req.params.id) }, function(err, docs) {
                res.redirect('/admin/posts');
            });
        },

        activate: function(req, res) {
            req.mongo.collection('posts').update({ _id: new ObjectID(req.params.id) }, {$set: {active: true}} , function(err, docs) {
                res.redirect('/admin/posts');
            });
        },
    },

    categories: {
        index: function(req, res) {
            req.mongo.collection('categories').find({}).toArray(function(err, categories) {
                res.render('categories/index', {
                    categories: categories
                });
            });

        },

        new: function(req, res) {
            res.render('categories/new', { errors: [], category: {} });
        },


        post: function(req, res) {
            req.checkBody('name', 'Nazwa kategorii nie może być pusta.').notEmpty();

            var errors = req.validationErrors(true);

            if (errors) {
                return res.render('categories/new', {
                    errors: errors,
                    category: {}
                });
            }

            var slug = require('slug');
            req.body.slug = slug(req.body.name).toLowerCase();

            req.mongo.collection('categories').insert(req.body, function(err, docs) {
                res.redirect('/admin/categories');
            });
        },


        delete: function(req, res) {
            req.mongo.collection('categories').remove({ _id: new ObjectID(req.params.id) }, function(err, docs) {
                res.redirect('/admin/categories');
            });
        }
    }
};
