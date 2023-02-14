root = exports ? this

root.paginate = (bookHtml) ->

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
          console.log "closeres yes!"

          if tagStack[tagStack.length - 1] is closeRes[1]
            tagStack.pop()
            # console.log "good tag pop"
          else
            # console.log "BOGUS TAG!"
            # console.log "last tag: " + tagStack[tagStack.length - 1]
            # console.log "this tag: " + closeRes[1]
          console.log tagStack

    tagStack

  # Split on tags and whitespace
  tokenizationPatt = /(<[^>]+>|\s)/
  words = bookHtml.split tokenizationPatt

  pageBrTag = '<pagebr />'

  console.log "word len: "
  console.log words.length

  pages = []
  pageId = 0
  wordId = 0
  currentWords = []

  chunkSize = 1

  tagStack = []

  console.log "height: " + $('#sizer').height()

  while wordId < words.length

    $('#sizer').html(currentWords.join('') + words[wordId])

    if $('#sizer').height() > 600 or words[wordId] is pageBrTag

      console.log "height: " + $('#sizer').height()
      console.log "OVER!! on word " + words[wordId]

      reopenedTags = []
      # If we have an intentional page break, we don't want to do any of the 
      # other fixes, but we do want to throw away the current word

      if words[wordId] == pageBrTag
        console.log "PAGE BREAK"
        wordId += 1

      else 

        # If we have any opening tags at the end of our current words, we want
        # to move those off. For example, if we end currentWords with
        # ["<p>", "<b>"], those should be moved back on to the words pile to
        # begin the next page.
        while currentWords[currentWords.length - 1].match /^<([^>\/]+)>$/
          console.log "popping off " + currentWords[currentWords.length - 1]
          currentWords.pop()
          wordId -= 1

        # We want to avoid starting a new page with a single line that ends
        # a paragraph. We'll move that last line onto the current page if
        # we can. This will make the current page one line longer than most
        # pages, but that's better than stranding it alone at the beginngin of
        # the next page.
        console.log "wordId: ", wordId
        console.log "beginning to look for </p>, starting at word" + currentWords[currentWords.length - 1]
        console.log "next words:" + words.slice(wordId, 5)
        console.log "$('#sizer').height = ", $('#sizer').height()

        tmpWordId = wordId
        tmpCurrentWords = currentWords.slice 0 # clone current array
        keepLooking = true

        # If we just ended a paragraph, don't add anything else to this page
        if currentWords[currentWords.length - 1] == '</p>' or words[wordId] == '<p>'
          console.log "not adding more to page because encountered", words[wordId]
          keepLooking = false
        
        while keepLooking
          $('#sizer').html(tmpCurrentWords.join('') + words[tmpWordId])
          if $('#sizer').height() > 610 or tmpWordId > words.length
            keepLooking = false
          else if words[tmpWordId] == '</p>' or words[tmpWordId] == pageBrTag
            if words[tmpWordId] != pageBrTag
              tmpCurrentWords.push(words[tmpWordId])
            keepLooking = false
            wordId = tmpWordId
            if words[tmpWordId] == pageBrTag
              wordId += 1
            currentWords = tmpCurrentWords
            console.log "!!!!!!!!!found", words[tmpWordId],  "and saved the page!!!! "
            console.log currentWords
            console.log "wordId: ", wordId
          else
            tmpCurrentWords.push(words[tmpWordId])
            tmpWordId += 1

        console.log "OVER!! afterwards, on word " + words[wordId]
        console.log "wordId: ", wordId
        
        # Unclosed tags for the current page should be closed, then opened
        # again at the beginning of the next page. <p> should be non-indenting
        # if re-opened.
        unbalancedTags = findUnbalancedTags(currentWords)
        for unbalancedTag in unbalancedTags.reverse()
          currentWords.push '</' + unbalancedTag + '>'
          if unbalancedTag is 'p'
            reopenedTags.unshift '<p class="noindent">'
          else
            reopenedTags.unshift '<' + unbalancedTag + '>'

        console.log "XXXXXunbalanced: " + unbalancedTags

      while words[wordId] in ['</p>', ' ', '\n', ' \n']
        console.log "push ahead:", words[wordId]
        wordId += 1

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

      while words[wordId] in ['</p>', ' ', '\n']
        console.log "push ahead:", words[wordId]
        wordId += 1

      pages[pageId] = thisPage
      pageId += 1

      sliceEnd = if wordId + chunkSize > words.length then words.length else wordId + chunkSize
      chunk = reopenedTags.concat words.slice(wordId, sliceEnd)
      $('#sizer').html(chunk.join(''))
      
      currentWords = chunk

      console.log "making page: " + (pageId - 1).toString()
      console.log "page: " + pages[pageId - 1]
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
  pages[pageId] = thisPage

  console.log "Done. Num pages: " + pages.length

  pages