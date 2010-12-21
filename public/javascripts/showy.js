$.fn.showy = function(){
  return this.each(function(){
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
}

$.fn.shorten = function(){
  var shorten = $(this).attr('href');
  var text = $(shorten).text().trim();
  var max = 85
  function trunc(text) {
    var shortText = text
        .substring(0, max)
        .split(" ")
        .slice(0, -1)         
        .join(" ") + "...";
    $(shorten).html(shortText).addClass('shortened');
  }
  
  if (!$(shorten).hasClass('shortened')) {
    trunc(text);
  }
  $(this).click(function() {
    if ($(shorten).hasClass('shortened')) { // show all
      $(shorten).html(text).removeClass('shortened');
       $(this).html($(this).text().replace(/View/, 'Close'));
    } else {
      trunc(text);
       $(this).html($(this).text().replace(/Close/, 'View'));
    }
    return false;
  });
}

