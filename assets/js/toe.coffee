$ ->
  console.log "hi!"

  $('.navItem, .titleNavItem, .storeTitle, .storeCover').click (event) ->
    console.log "nav click"
    console.log event
    console.log this
    go $(this).attr("target")

  $('#stamp').click (e) ->
    go 'home'

  $('#ttp').click (e) ->
    go 'home'

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

  $(window).bind 'hashchange', (e) ->
    where = $.param.fragment()
    go where

  $(window).trigger 'hashchange'

  # $("body").swipe
  #   swipeRight: () ->
  #     console.log 'swiped left'
  #     go 'backward'
  #   swipeLeft: () ->
  #     console.log 'swiped right'
  #     go 'forward'


go = (where) ->
  console.log 'go: where: ' + where
  if where == 'forward'
    console.log 'go: forward!'
    if pageNumber < numPages
      goToPage pageNumber + 1
  else if where == 'backward'
    console.log 'go: backward!'
    if pageNumber > 0
      goToPage pageNumber - 1
  else if where == 'home' or $('#' + where + 'Nav.navItem').length or $('#' + where + 'Nav.titleNavItem').length # Main nav item
    window.location.hash = where
    console.log "found where:", where
    nav = $('#' + where + '.navItem')
    subnav = $('#' + where + " subnavItem:first")
    
    $('.navItem').removeClass 'active'

    $('#' + where + 'Nav').addClass 'active'
    
    $('.innerBlock').hide()
    $('#' + where).show()

    if (where != 'about')
      console.log "where: ", about
      html = $('#movieCtn').html()
      console.log "html: ", html
      $('#movieCtn').html('')
      console.log html, $('#movieCtn').html()
      $('#movieCtn').html(html)

    console.log('showing', where)
    nav.addClass 'active'
    subnav.addClass 'active'

    return false
