$(function() {
  $nav = $('nav');
  $blackOut = $('.black-out');

  drawerIn();

  $('.menu-icon').on('click', function() {
    drawerOut();
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

  function drawerOut() {
    $nav.addClass('drawer-out');
    $blackOut.removeClass('hidden');
  }

});