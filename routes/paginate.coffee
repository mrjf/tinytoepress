routes = (app) ->

  app.get '/paginate/:bookSlug', (req, res) ->

    bookSlug = req.params.bookSlug

    console.log "paginate: ", bookSlug

    bookHtml = req.library.getText bookSlug

    res.render 'paginate'
      title: 'paginater'
      bookSlug: bookSlug
      bookHtml: bookHtml

  
  app.post '/paginationResult/:bookSlug', (req, res) ->

    pages = req.body.pages

    console.log "paginationResult"

    fs = require 'fs'
    fs.writeFile '/tmp/' + req.params.bookSlug + '.pages.json',
                 JSON.stringify req.body.pages, null, 4

    res.json "ok!"

module.exports = routes
