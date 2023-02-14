routes = (app) ->

  app.get '/read/', (req, res) ->
    res.send 'Hello book'

  app.get '/read/:bookSlug', (req, res) ->

    book = req.library.books[req.params.bookSlug]

    if not book
      res.send('Book not found', 404)
    else
      res.render 'page',
        title: "#{book.title} by #{book.author}"
        bookTitle: book.title
        bookSlug: req.params.bookSlug
        numPages: book.numPages()
        numIntroPages: book.numIntroPages
        frontMatter: book.frontMatter

  app.get '/page/:bookSlug/:pageNumber', (req, res) ->

    console.log (req.library)
    console.log (req)

    pageHtml = req.library.getPage req.params.bookSlug, req.params.pageNumber

    console.log "page number: " + req.params.pageNumber
    console.log "pageHtml: " + pageHtml

    if pageHtml
      res.json
        pageHtml: pageHtml
    else
      res.send('Page not found', 404)

  app.get '/read/:book', (req, res) ->

    if req.params.book.toLowerCase().replace(/[^a-z]/g, "") == 'austinnights'
      res.redirect '/read/Austin_Nights'
    else
      res.send('what book???', 404);

  app.get '*', (req, res) ->
    res.send('Page not found', 404);



module.exports = routes
