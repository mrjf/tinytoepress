$ ->
  console.log "paginater!"

  bookHtml = $('#bookHtml').val()

  pages = window.paginate bookHtml

  console.log 'All done got pages:', pages.length

  $.post('/paginationResult/' + $('#bookSlug').val(),
      pages: pages)

