express = require "express"
engine = require "ejs-locals"

app = module.exports = express()

app.engine "ejs", engine
app.set "view engine", "ejs"
app.set "views", __dirname + "/views"

jobs = require("./controllers/jobs")

# GET /jobs
app.get '/jobs', jobs.index

# GET /jobs/new
app.get '/jobs/new', jobs.create

# GET /jobs/:category
app.get '/jobs/:category', jobs.category

# GET /job/offer/:id
app.get '/job/offer/:id', jobs.show

# POST /job/offer/:id
app.post '/job/offer/:id', jobs.bid

# POST /jobs/new
app.post '/jobs/new', jobs.post