$ ->
  console.log "hi!"

  [window.pageNumber, window.pageSlug] = getPageInfo()

  console.log "pageNumber: " + pageNumber
  console.log "pageSlug: " + pageSlug

  goToPage pageNumber

  $('.prev').click (e) ->
    go 'backward'

  $('.next').click (e) ->
    go 'forward'

  $('#watermark').click (e) ->
    go 'home'

  $('#pageHead').click (e) ->
    go 'cover'

  $(document).keyup (event) ->
    if event.altKey || event.ctrlKey || event.shiftKey || event.metaKey
      return
    if event.keyCode == 37
      console.log 'key 37'
      go 'backward'
    else if event.keyCode == 39 or event.keyCode == 32
      console.log 'key 39 or 32'
      go 'forward'

  $("body").swipe
    swipeRight: () ->
      console.log 'swiped left'
      go 'backward'
    swipeLeft: () ->
      console.log 'swiped right'
      go 'forward'



go = (where) ->
  console.log 'go: page number:' + pageNumber
  console.log 'go: page slug:' + pageSlug
  console.log 'go: numPages: ' + numPages
  if where == 'forward'
    console.log 'go: forward!'
    if pageNumber < numPages
      goToPage pageNumber + 1
  else if where == 'backward'
    console.log 'go: backward!'
    if pageNumber > 0
      goToPage pageNumber - 1
  else if where == 'home'
    console.log 'go: home!'
    window.location = '/'
  else if where == 'cover'
    console.log 'go: cover!'
    window.location = '/read/' + bookSlug

setNav = () ->
  console.log "setNav: numPages: " + numPages
  console.log "setNav: pageNumber + 1: " + (pageNumber + 1)
  console.log "setNav: typeof(pageNumber) + 1: " + (pageNumber + 1)
  if pageNumber + 1 >= numPages
    $('a.nav.next').addClass 'disabled'
  else
    $('a.nav.next').removeClass 'disabled'

  if pageNumber < 1
    $('a.nav.prev').addClass 'disabled'
  else
    $('a.nav.prev').removeClass 'disabled'

  console.log 'setnav'

goToPage = (pageNumber) ->
  console.log "goToPage: pageNumber: " + pageNumber
  $.getJSON '/page/' + bookSlug + '/' + pageNumber, (data) ->
    $('#pageHtml').html data.pageHtml
    window.pageNumber = pageNumber
    window.pageSlug = getPageSlugFromPageNumber pageNumber
    window.location.hash = pageSlug
    setPageNumberDisplay pageSlug
    setNav()

# pageNumber 0, frontMatter []: pageSlug 1    x + 1 - frontMatter.length
# pageNumber 1, frontMatter []: pageSlug 2    x + 1 - frontMatter.length
# pageNumber 1, frontMatter ['bar']: pageSlug 1  x + 1 - frontMatter.length
# pageNumber 2, frontMatter ['bar']: pageSlug 2  x + 1 - frontMatter.length
# pageNumber 0, frontMatter ['bar']: pageSlug 'bar' frontMatter[0] frontMatter[pageNumber]
# pageNumber , frontMatter ['bar']: pageSlug 'bar' frontMatter[0] frontMatter[pageNumber]
getPageSlugFromPageNumber = (pageNumber) ->
  console.log "getPageSlugFromPageNumber: pageNumber: " + pageNumber
  console.log "getPageSlugFromPageNumber: typeof(pageNumber): " + typeof(pageNumber)
  console.log "getPageSlugFromPageNumber: frontMatter: " + frontMatter
  console.log "getPageSlugFromPageNumber: pageNumber in frontMatter: " + pageNumber in frontMatter
  if pageNumber < frontMatter.length
    console.log "getPageSlugFromPageNumber: is in frontMatter: " + frontMatter[pageNumber]
    frontMatter[pageNumber]
  else
    pageNumber + 1 - frontMatter.length

getPageNumberFromPageSlug = (pageSlug) ->
  for slug, pageNumber in frontMatter
    if slug is pageSlug
      return pageNumber
  parseInt(pageSlug) + frontMatter.length - 1

setPageNumberDisplay = (pageSlug) ->
  if typeof(pageSlug) is 'number'
    $('#displayPageNumber').html pageSlug
  else
    $('#displayPageNumber').html ''

getPageInfo = () ->

  if window.location.hash
    pageSlug = window.location.hash.substring 1
    pageNumber = getPageNumberFromPageSlug pageSlug
  else
    pageNumber = 0
    pageSlug = getPageSlugFromPageNumber pageNumber

  [pageNumber, pageSlug]

# Get the previous and next n pages
preload = (n) ->

