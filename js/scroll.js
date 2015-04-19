$(function(){
  var sections = {},
      _height = $(window).height(),
      i = 0;

  // Grab positions of our sections 
  $('section').each(function() {
    sections[this.id] = $(this).offset().top;
  });

  $(document).scroll(function() {
    var $this = $(this),
        pos   = $this.scrollTop();
        
    for(sec in sections) {
      if(sections[sec] > pos && sections[sec] < pos + _height) {
        $('a').removeClass('active');
        $('a[href="#' + sec +'"]').addClass('active');
      }
    }
  });

  $('nav a').on('click', function() {
    $('a').removeClass('active');
    $(this).addClass('active');
  });
  
});