// public/javascripts/application.js
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}
});

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  });
  return this;
};

$(document).ready(function() {
	
// Add the authenticity token to all POST-like requests, preventing XSS
	$("body").bind("ajaxSend", function(elm, xhr, s) {
		if (s.type == "GET") return;
		if (s.data && s.data.match(new RegExp("\\b" + window._auth_token_name + "="))) return;
		if (s.data) {
			s.data = s.data + "&";
		} else {
			s.data = "";
			// if there was no data, $ didn't set the content-type
			xhr.setRequestHeader("Content-Type", s.contentType);
		}
		s.data = s.data + encodeURIComponent(window._auth_token_name) + "=" + encodeURIComponent(window._auth_token);
	});

// Ajaxify the New Status form
	$("#new_status").submitWithAjax();
	
// Ajaxy Delete
	$('#statuses a.trash').live('click', function(){
		$.post(this.href, { _method: 'delete' }, null, 'script');
		return false;	
	});

	$('a.delete, a.trash').removeAttr('onclick');
});


// Hide the filter form by default on Admin search

$("#filter").hide();

$("a.showtarget").click(function(){
	$(this.hash).slideToggle('fast');
	return false;
});



// Show Current State indicators

$("#navigation a[href$=" + window.location.pathname + "]").parent().addClass("selected");


