jobs = module.exports = {}

JobCategory = require '../models/job-category'
Job = require '../models/offer'
Bid = require '../models/job-bid'

slug = require 'slug'

PER_PAGE = 20

jobs.index = (req, res) ->
  page = req.query.page || 1

  JobCategory.find {}, (err, categories) ->
    Job.find {}, {},
      sort:
        createdAt: -1
    .populate 'category'
    .paginate page, PER_PAGE, (err, jobs, total) ->
      pagination = require 'pagination'

      res.render 'jobs/index',
        categories: categories,
        jobs: jobs,
        pager: pagination.create '/jobs',
          prelink: '/jobs'
          current: page
          rowsPerPage: PER_PAGE
          totalResult: total

jobs.show = (req, res) ->
  JobCategory.find {}, (err, categories) ->
    Job.findOne
      _id: req.params.id, (err, job) ->
        bidForm = require '../forms/bid'

        Bid.find
          job: req.params.id
        .populate 'user'
        .populate 'job'
        .exec (err, bids) ->
            res.render 'jobs/show',
              categories: categories
              job: job,
              bidForm: bidForm.toHTML(),
              bids: bids

jobs.bid = (req, res) ->
  JobCategory.find {}, (err, categories) ->
    Job.findOne
      _id: req.params.id, (err, job) ->
        bidForm = require '../forms/bid'

        bidForm.handle req.body,
          success: (form) ->
            bidData = req.body
            bidData.user = res.locals.user
            bidData.job = job

            bid = new Bid bidData
            bid.save (err, result) ->
              req.flash 'notice', 'Twoja oferta została złożona'

              res.redirect 'back'
          error: (form) ->
            res.render 'jobs/show',
              categories: categories
              job: job,
              bidForm: bidForm.toHTML()

jobs.category = (req, res) ->
  page = req.query.page || 1

  JobCategory.find {}, (err, categories) ->
    JobCategory.findOne
      slug: req.params.category, (err, category) ->
        return res.redirect '/' if !category

        Job.find
          category: category._id
        , {},
          sort:
            createdAt: -1
        .populate 'category'
        .paginate page, PER_PAGE, (err, jobs, total) ->
            pagination = require 'pagination'

            res.render 'jobs/index',
              categories: categories,
              jobs: jobs,
              pager: pagination.create '/jobs',
                prelink: '/jobs'
                current: page
                rowsPerPage: PER_PAGE
                totalResult: total

jobs.create = (req, res) ->
  JobCategory.find {}, (err, categories) ->

    categoryHash = []

    categories.forEach (category) ->
      categoryHash[category._id] = category.name

    form = require('../forms/create') categoryHash

    res.render 'jobs/create',
      categories: categories,
      form: form.toHTML()

jobs.post = (req, res) ->
  JobCategory.find {}, (err, categories) ->

    categoryHash = []

    categories.forEach (category) ->
      categoryHash[category._id] = category.name

    form = require('../forms/create') categoryHash

    form.handle req.body,
      success: (form) ->
        job = new Job req.body
        job.save (err, result) ->
          req.flash 'notice', 'Twoje zlecenie zostało dodane'

          res.redirect '/jobs'
      error: (form) ->
        res.render 'jobs/create',
          categories: categories,
          form: form.toHTML()