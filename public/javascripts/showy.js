jQuery.fn.showy = function(){
  return $(this).each(function(){
    var hidable = $(this.hash);

    // Just in case it starts out shown, hide it
    if (hidable.is(":visible")) {
      hidable.hide();
      hidable.removeClass('open');
    }

    $(this).click(function(e) {
      var link = $(this);
      hidable.slideToggle(200);
      link.toggleClass('open');
      hidable.toggleClass('open');
      
      var text = link.html();
      if (link.hasClass('open')) {
        link.html(text.replace(/View/, 'Close'));
      } else {
        link.html(text.replace(/Close/, 'View'));
      }
      return false;
    });
  });
};