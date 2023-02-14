system = require 'system'
fs = require 'fs'

if system.args.length != 3
  console.log 'Usage: paginate.coffee bookSlug filename'
  phantom.exit 1
else
  bookSlug = system.args[1]
  filename = system.args[2]

if not system.env.CTB_CONF
    throw "Environment variable CTB_CONF is not set; point it to your conf file"
conf = require system.env.CTB_CONF

book = conf.books.filter((x) -> x.slug == bookSlug)[0]

console.log book.htmlFile

bookHtml = fs.read('../' + book.htmlFile)
console.log "bookHtml: ", bookHtml
# Split on tags and whitespace
tokenizationPatt = /(<[^>]+>|\s)/
words = bookHtml.split tokenizationPatt
console.log "bookHtml: ", bookHtml
console.log "word len: "
console.log words.length

page = require('webpage').create()

page.open 'http://localhost:3000/paginateBlank', () ->

  console.log "page opened"

  page.includeJs 'http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js', () ->

    console.log "jquery included"

    console.log "about to eval"

    pages = page.evaluate paginateBook, words

    console.log
    
    console.log "pages:"
    console.log "length:", pages.length
    console.log pages

    fh = outfile = fs.open filename, 'w'
    fh.write JSON.stringify(pages, null, 2)
    fh.close()

    phantom.exit()

paginateBook = (words) ->

  tokenizationPatt = /(<[^>]+>|\s)/

  findUnbalancedTags = (words) ->

    tagStack = []

    for word in words
      # console.log "word: " + word
      openRes = word.match /^<([^>\/\s]+)(\s[^>\/\s]+)?>$/
      if openRes
        # console.log "open res yes!"
        tagStack.push openRes[1]
        # console.log tagStack
      else
        closeRes = word.match /^<\/([^>]+)>$/
        if closeRes
          if tagStack[tagStack.length - 1] is closeRes[1]
            tagStack.pop()

    tagStack


  window.pages = []
  pageId = 0
  wordId = 0
  currentWords = []

  chunkSize = 100

  tagStack = []

  while wordId < words.length
  # while wordId <= 3000

    $('#sizer').html(currentWords.join('') + words[wordId])

    if $('#sizer').height() > 600

      console.log "height: " + $('#sizer').height()
      console.log "OVER!! on word " + words[wordId]

      # We want to avoid starting a new page with a single line that ends
      # a paragraph. We'll move that last line onto the current page if
      # we can. This will make the current page one line longer than most
      # pages, but that's better than stranding it alone at the beginngin of
      # the next page.
      console.log "wordId: ", wordId
      console.log "beginning to look for </p>, starting at word" + currentWords[currentWords.length - 1]
      console.log "$('#sizer').height = ", $('#sizer').height()
      keepLooking = true
      tmpWordId = wordId
      tmpCurrentWords = currentWords.slice 0 # clone current array
      # If we are already ending on a </p>, then we're fine, don't look.
      if currentWords[currentWords.length - 1] == '</p>'
        console.log 'current word is </p>, not trying to continue with another line'
        keepLooking = false
      while keepLooking
        $('#sizer').html(tmpCurrentWords.join('') + words[tmpWordId])
        if $('#sizer').height() > 610 or tmpWordId > words.length
          keepLooking = false
        else if words[tmpWordId] == '</p>'
          tmpCurrentWords.push(words[tmpWordId])
          keepLooking = false
          wordId = tmpWordId
          currentWords = tmpCurrentWords
          console.log "!!!!!!!!!found </p> and saved the page!!!! "
          console.log currentWords
          console.log "wordId: ", wordId
        else
          tmpCurrentWords.push(words[tmpWordId])
          tmpWordId += 1

      console.log "OVER!! afterwards, on word " + words[wordId]
      console.log "wordId: ", wordId

      # If we have any opening tags at the end of our current words, we want
      # to move those off. For example, if we end currentWords with
      # ["<p>", "<b>"], those should be moved back on to the words pile to
      # begin the next page.
      while currentWords[currentWords.length - 1].match /^<([^>\/]+)>$/
        console.log "popping off " + currentWords[currentWords.length - 1]
        currentWords.pop()
        wordId -= 1

      # Unclosed tags for the current page should be closed, then opened
      # again at the beginning of the next page. <p> should be non-indenting
      # if re-opened.
      unbalancedTags = findUnbalancedTags(currentWords)
      reopenedTags = []
      for unbalancedTag in unbalancedTags.reverse()
        currentWords.push '</' + unbalancedTag + '>'
        if unbalancedTag is 'p'
          reopenedTags.unshift '<p class="noindent">'
        else
          reopenedTags.unshift '<' + unbalancedTag + '>'


      console.log "XXXXXunbalanced: " + unbalancedTags

      # If we end the page on a chapter-heading h3, this is bad. We should move
      # that h3 off the current page and rewind the wordId to compensate.
      thisPage = currentWords.join ''
      terminalH3Patt = /(\s*<h3[^>]*>[^<]+<\/h3>\s*)$/
      h3Match = thisPage.match terminalH3Patt
      if h3Match
        console.log "page matches terminalH3Patt: " + thisPage
        thisPage = thisPage.replace terminalH3Patt, ''
        wordId -= h3Match[0].split(tokenizationPatt).length
        console.log "page without h3Match: " + thisPage

      window.pages[pageId] = thisPage
      pageId += 1

      sliceEnd = if wordId + chunkSize > words.length then words.length else wordId + chunkSize
      chunk = reopenedTags.concat words.slice(wordId, sliceEnd)
      $('#sizer').html(chunk.join(''))
      
      currentWords = chunk

      console.log "making page: " + (pageId - 1).toString()
      console.log "page: " + window.pages[pageId - 1]
      console.log "wordId: " + wordId
      console.log "chunkSize: " + chunkSize
      console.log "words.length: " + words.length
      console.log 'sliceEnd: ' + sliceEnd
      console.log 'first word:' + words[wordId]
      console.log 'last word:' + words[sliceEnd]
      console.log "next chunk: "
      console.log chunk

      wordId += chunkSize

    else
      currentWords.push words[wordId]
      wordId += 1

  thisPage = currentWords.join ''
  window.pages[pageId] = thisPage

  window.pages

