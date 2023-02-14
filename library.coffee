fs = require 'fs'

class Book

  constructor: (@title, @author, @slug, textFile, pagesFile, @frontMatter) ->
    console.log "constructor: "
    console.log @title
    console.log @slug
    console.log textFile
    console.log pagesFile
    console.log " "
    @text = @loadText(textFile)
    console.log "@text: "
    console.log @text.substring(0, 15)
    @pages = @loadPages(pagesFile)
    console.log @pages[0].substring(0, 15)

  loadText: (file) ->
    fs.readFileSync(file).toString()

  loadPages: (file) ->
    text = fs.readFileSync(file).toString()
    # console.log text
    JSON.parse(text)

  numPages: ->
    @pages.length

  getPageSlug: (pageNumber) ->
    if pageNumber < @frontMatter.length
      @frontMatter[pageNumber]
    else
      pageNumber - @frontMatter.length

class Library

  constructor: (@name) ->
    @books = {}

  addBook: (book) ->
    @books[book.slug] = new Book book.title, book.author, book.slug, book.htmlFile, book.pagesFile, book.frontMatter

  getPage: (bookSlug, pageNumber) ->
    @books[bookSlug].pages[pageNumber]

  getPageSlug: (bookSlug, pageNumber) ->
    @books[bookSlug].getPageSlug pageNumber

  getText: (bookSlug) ->
    @books[bookSlug].text


module.exports = (libraryName, books) ->
  library = new Library(libraryName)

  console.log "books:"
  console.log books

  library.addBook book for book in books

  library


