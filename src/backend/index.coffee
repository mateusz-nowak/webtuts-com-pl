express = require("express")
engine = require("ejs-locals")
route = require("./controllers")
validation = require("express-validator")
app = module.exports = express()
app.engine "ejs", engine
app.set "view engine", "ejs"
app.set "views", __dirname + "/views"
app.use validation()
# app.use "/admin", (req, res, next) ->
#   res.redirect "/"  unless req.user
#   next()
#   return


# GET /admin
app.get "/admin", route.dashboard

# GET /admin/categories
app.get "/admin/categories", route.categories.index

# POST /admin/categories
app.post "/admin/categories", route.categories.post

# GET /admin/categories/new
app.get "/admin/categories/new", route.categories.create

# GET /admin/categories/:id/delete
app.get "/admin/categories/:id/delete", route.categories.destroy

# GET /admin/posts
app.get "/admin/posts", route.posts.index

# GET /admin/posts/new
app.get "/admin/posts/new", route.posts.create

# POST /admin/posts
app.post "/admin/posts", route.posts.post

# GET /admin/posts/:id
app.get "/admin/posts/:id", route.posts.show

# GET /admin/posts/:id/delete
app.get "/admin/posts/:id/delete", route.posts.destroy

# GET /admin/posts/:id/activate
app.get "/admin/posts/:id/activate", route.posts.activate

# GET /admin/posts/:id/edit
app.get "/admin/posts/:id/edit", route.posts.edit

# PUT /admin/posts/:id/edit
app.put "/admin/posts/:id", route.posts.update

# GET /admin/contents
app.get '/admin/contents', route.contents.index

# GET /admin/contents/new
app.get '/admin/contents/new', route.contents.create

# POST /admin/contents
app.post '/admin/contents', route.contents.post

# GET /admin/contents/:id/delette
app.get '/admin/contents/:id/delete', route.contents.destroy
