var express = require('express');
var engine = require('ejs-locals');
var main = require('./controllers');

var app = module.exports = express();

app.engine('ejs', engine);
app.set('view engine', 'ejs');
app.set('views', __dirname + '/views');

app.get('/', main.index);
