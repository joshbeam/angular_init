$(function() {
  $nav = $('nav');
  $blackOut = $('.black-out');

  drawerIn();

  $('.menu-icon').on('click', function(e) {
    drawerOut(e);
  });

  $('.black-out').on('click', function() {
    drawerIn();
  });

  $('nav a').on('click', function() {
    drawerIn();
  });

  function drawerIn() {
    $nav.removeClass('drawer-out');
    $blackOut.addClass('hidden')
  }

  function drawerOut(event) {
    $nav.addClass('drawer-out');
    $blackOut.removeClass('hidden');
    event.preventDefault();
  }

});