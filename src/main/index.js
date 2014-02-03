var express = require('express'),
    engine = require('ejs-locals');

module.exports = app = express();

app.engine('ejs', engine);
app.set('view engine', 'ejs');
app.set('views', __dirname + '/views');

var main = require('./controllers/main');

app.get('/', main.index);
app.get('/create', main.create);
