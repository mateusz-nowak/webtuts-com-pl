var express = require('express');
var engine = require('ejs-locals');
var route = require('./controllers');

var app = module.exports = express();

app.engine('ejs', engine);
app.set('view engine', 'ejs');
app.set('views', __dirname + '/views');

app.get('/admin', route.dashboard);
app.get('/admin/categories', route.categories.index);
