var express = require('express');
var engine = require('ejs-locals');
var route = require('./controllers');
var validation = require('express-validator');
var app = module.exports = express();

app.engine('ejs', engine);
app.set('view engine', 'ejs');
app.set('views', __dirname + '/views');
app.use(validation());

app.use('/admin', function(req, res, next) {
    if (!req.user) {
        res.redirect('/');
    }

    next();
});

// GET /admin
app.get('/admin', route.dashboard);

// GET /admin/categories
app.get('/admin/categories', route.categories.index);

// POST /admin/categories
app.post('/admin/categories', route.categories.post);

// GET /admin/categories/new
app.get('/admin/categories/new', route.categories.new);

// GET /admin/categories/:id/delete
app.get('/admin/categories/:id/delete', route.categories.delete);

// GET /admin/posts
app.get('/admin/posts', route.posts.index);

// GET /admin/posts/new
app.get('/admin/posts/new', route.posts.new);

// POST /admin/posts
app.post('/admin/posts', route.posts.post);

// GET /admin/posts/:id
app.get('/admin/posts/:id', route.posts.show);

// GET /admin/posts/:id/delete
app.get('/admin/posts/:id/delete', route.posts.delete);

// GET /admin/posts/:id/activate
app.get('/admin/posts/:id/activate', route.posts.activate);

// GET /admin/posts/:id/edit
app.get('/admin/posts/:id/edit', route.posts.edit);

// PUT /admin/posts/:id/edit
app.put('/admin/posts/:id', route.posts.update);
