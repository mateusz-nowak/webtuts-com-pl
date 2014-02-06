var express = require('express');
var engine = require('ejs-locals');
var mongoJoin = require('mongo-join').Join;
var app = module.exports = express();

app.engine('ejs', engine);
app.set('view engine', 'ejs');
app.set('views', __dirname + '/views');

app.get('/categories/:slug', function(req, res) {
    var categoryCollection = req.mongo.collection('categories');
    var postCollection = req.mongo.collection('posts');
    var ObjectID = require('mongodb').ObjectID;

    new mongoJoin(req.mongo).on({
        'field': 'category',
        'to': '_id',
        'from': 'categories'
    }).findOne(req.mongo.collection('categories'), { slug: req.params.slug }, [], function(err, category) {
    });
});

