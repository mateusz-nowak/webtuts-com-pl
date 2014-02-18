express = require("express")
engine = require("ejs-locals")
route = require("./controllers")
app = module.exports = express()

app.engine "ejs", engine
app.set "view engine", "ejs"
app.set "views", __dirname + "/views"

# GET /
app.get "/forum", route.index

# GET /forum/threads/new
app.get '/forum/threads/new', route.create

# POST /forum/threads/new
app.post '/forum/threads/new', route.post

# GET /forum/:id
app.get '/forum/:id', route.show

# GET /forum/:id/posts/new
app.get '/forum/:id/posts/new', route.posts.create

# POST /forum/:id/posts/new
app.post '/forum/:id/posts/new', route.posts.post

# GET /forum/:thread/posts/:post/remove
app.get '/forum/:thread/posts/:post/remove', route.posts.remove
