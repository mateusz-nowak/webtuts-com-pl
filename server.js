var app = require('./app');
var http = require('http');

http.createServer(app).listen(process.env.PORT || 3000);
