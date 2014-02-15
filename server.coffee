app = require './app'
http = require 'http'
http.createServer(app).listen process.env.PORT or 3000
