var express = require('express');
var engine = require('ejs-locals');
var main = require('./controllers');

var app = module.exports = express();

/**
 * Get all categories as local response variable
 */
app.use(function(req, res, next) {
    var collection = req.mongo.collection('categories');

    collection.find({}).toArray(function(err, categories) {
        res.locals.categories = categories;

        next();
    });
});

app.engine('ejs', engine);
app.set('view engine', 'ejs');
app.set('views', __dirname + '/views');

app.get('/', main.index);
