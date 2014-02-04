var express = require('express');
var http = require('http');
var app = express();
var yaml = require('yamljs');
var path = require('path');
var sass = require('node-sass');

app.configure('development', function() {
    app.set('configuration', yaml.load('config/development.yml'));
    app.use(express.errorHandler());
    app.use(sass.middleware({
        src: __dirname + '/public/sass',
        dest: __dirname + '/public/css',
        debug: true,
        prefix: '/css'
    }));
});

app.configure('production', function() {
    app.set('configuration', yaml.load('config/production.yml'));
    app.use(sass.middleware({
        src: __dirname + '/public/sass',
        dest: __dirname + '/public/css',
        prefix: '/css'
    }));
});

app.configure(function() {
    //app.use(require('./middleware/mongo'));
    app.use(express.json());
    app.use(express.bodyParser());
    app.use(express.urlencoded());
    app.use(express.methodOverride());
    app.use(express.cookieParser());
    app.use(app.router);
    app.use(express.session({
        secret: 'secret-hash',
        expires: new Date(Date.now() + 360000),
        maxAge: 360000
    }));
    app.use(express.static(path.join(__dirname, 'public')));
    module.paths.push(__dirname+ '/src');
});

app.use(require('categories'));
app.use(require('posts'));
app.use(require('admin'));

http.createServer(app).listen(process.env.PORT || 3000);
