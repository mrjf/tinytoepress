(function() {
  var go;

  $(function() {
    console.log("hi!");
    $('.navItem, .titleNavItem, .storeTitle, .storeCover').click(function(event) {
      console.log("nav click");
      console.log(event);
      console.log(this);
      return go($(this).attr("target"));
    });
    $('#stamp').click(function(e) {
      return go('home');
    });
    $('#ttp').click(function(e) {
      return go('home');
    });
    $('.prev').click(function(e) {
      return go('backward');
    });
    $('.next').click(function(e) {
      return go('forward');
    });
    $('#watermark').click(function(e) {
      return go('home');
    });
    $('#pageHead').click(function(e) {
      return go('cover');
    });
    $(document).keyup(function(event) {
      if (event.altKey || event.ctrlKey || event.shiftKey || event.metaKey) {
        return;
      }
      if (event.keyCode === 37) {
        console.log('key 37');
        return go('backward');
      } else if (event.keyCode === 39 || event.keyCode === 32) {
        console.log('key 39 or 32');
        return go('forward');
      }
    });
    $(window).bind('hashchange', function(e) {
      var where;
      where = $.param.fragment();
      return go(where);
    });
    return $(window).trigger('hashchange');
  });

  go = function(where) {
    var html, nav, subnav;
    console.log('go: where: ' + where);
    if (where === 'forward') {
      console.log('go: forward!');
      if (pageNumber < numPages) {
        return goToPage(pageNumber + 1);
      }
    } else if (where === 'backward') {
      console.log('go: backward!');
      if (pageNumber > 0) {
        return goToPage(pageNumber - 1);
      }
    } else if (where === 'home' || $('#' + where + 'Nav.navItem').length || $('#' + where + 'Nav.titleNavItem').length) {
      window.location.hash = where;
      console.log("found where:", where);
      nav = $('#' + where + '.navItem');
      subnav = $('#' + where + " subnavItem:first");
      $('.navItem').removeClass('active');
      $('#' + where + 'Nav').addClass('active');
      $('.innerBlock').hide();
      $('#' + where).show();
      if (where !== 'about') {
        console.log("where: ", about);
        html = $('#movieCtn').html();
        console.log("html: ", html);
        $('#movieCtn').html('');
        console.log(html, $('#movieCtn').html());
        $('#movieCtn').html(html);
      }
      console.log('showing', where);
      nav.addClass('active');
      subnav.addClass('active');
      return false;
    }
  };

}).call(this);
