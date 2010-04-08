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
$('.status a.trash').live('click', function(){
	$.post(this.href, { _method: 'delete' }, null, 'script');
	return false;	
});

$('a.delete, a.trash, .actions.destroy_link a').removeAttr('onclick');

$('.actions.destroy_link a').click(function(){
	var $destroyLink = $(this);
	if (confirm("Are you sure you want to PERMANENTLY delete this?")) {
		$.post(this.href+".js", {_method: 'delete'}, function(data, status){
			var row = $destroyLink.parents('tr:first');
			row.fadeOut(200,function(){
				row.remove();
			});
		});
	}
	return false;
});


// Hide the filter form by default on Admin search

$("#filter").hide();

$("a.showtarget").click(function(){
	$(this.hash).slideToggle('fast');
	return false;
});



// Show Current State indicators
var topLevelSection = window.location.pathname.split('/')[1];
if (topLevelSection == '') { topLevelSection = "home"; }
var $navigationList = $("#navigation");
$("a[href$=" + topLevelSection + "]", $navigationList)
  .add("a[href$=" + window.location.pathname + "]", $navigationList)
  .parent().addClass("selected");


// == Comment attachments

jQuery.fn.attachmentCloner = function() {
  return this.each(function(){
    var $attachmentFieldPrototype = $(this),
        attachmentCounter = 0,
        addNewLink;

    // Function to duplicate the markup, with new bindings on certain elements, and unique name field
    function smartCloneAttachment() {
      attachmentCounter++;
      if (!(addNewLink && addNewLink.size())) addNewLink = $(".add-another");

      // Start with the basics, from the protype field
      var $newfield = $attachmentFieldPrototype.clone();
      var fieldname = $newfield.find("input").attr("name");
      // Use a unique identifier, Rails requirement
      $newfield.find("input").attr("name", fieldname.replace(/(\d)/g, attachmentCounter)).attr('id', "");
      $newfield.insertBefore(addNewLink);

      // Add a remove link
      $newfield.find(".remove_attachment").click(function(){ $(this).parent().remove(); });

      return false;
    };

    // Add the new markup for add/remove links
    $attachmentFieldPrototype
    .append('<a class="remove_attachment" href="javascript:void(0)">Remove</a>')
    .after('<p class="add-another"><a href="javascript:void(0)">Add another attachment</a></p>')
    .next().find('a').click(smartCloneAttachment);

    // Cache this value for the smartCloneAttachment function
    addNewLink = $(".add-another");

    // Remove from DOM, but not memory
    $attachmentFieldPrototype.detach();

    // Let's do this!
    smartCloneAttachment();

  });
};

$(".attachfield:first").attachmentCloner();

// == Hidden fieldsets
var fieldsets = $("div.fieldsets").hide();

$("#media_request_media_request_type_id").bind('change', function(){
	fieldsets.hide();
	var val = $(this).find(":selected").attr("value");
	$("#fields_for_" + val).show();
}).change();


var calendarFields = fieldsets.find('input').filter(function(){
	return $(this).attr("id").match(/date/);
});

calendarFields.datepicker ({
	showAnim: 'fadeIn',
	constrainInput: false
});

// == Placebo Fields
var placeboFields = $("form .general_info input").not(":checkbox");
$("form .general_info :checkbox").change(function(){
	if(placeboFields.attr('disabled')) {
		placeboFields.removeAttr('disabled');
	} else {
		placeboFields.attr('disabled', 'disabled');
	}
});



// == Employee Autocomplete

$("#employment_employee_name").autocomplete("/users.js", {
	autoFill: true,
	max: 15
});

// == Filter Toggler ==
$("a.toggler").each(function(){
	var $div = $(this.hash);
	if ($div.length > 0) {
		$div.hide();
		$(this).click(function(){
			$div.slideToggle();
			$(this).toggleClass("open");
			return false;
		});
	}
});

// == Search checkboxes ==
// Dynamically "all" html...
var checkallItemString = '<li class="checkall_link"><label><input type="checkbox" class="novalue"/> Select All</label></li>';
// To these elements
var checkallList = $(".checkall ol");
var checkallLinks =  checkallList
	.prepend(checkallItemString)
	.find(".checkall_link :checkbox");

// bind action to links
checkallLinks.click(function(){
	$(this).parents('fieldset:eq(0)').find(':checkbox').attr('checked', this.checked);
});

// Uncheck the all
checkallList.find(":checkbox").not(".novalue").click(function(){
	if (this.checked) return true;
	$(this).parents('fieldset:eq(0)').find('.checkall_link :checkbox').removeAttr('checked');
});

//Cufon
// if(typeof(Cufon) != 'undefined') {
// 	Cufon.replace('.function-bold', {fontFamily:'FunctionBold', hover:true});
// }

// WYSIWYG
if(typeof(CKEDITOR) != 'undefined'){
	CKEDITOR.replace( 'page_content' );
}

$('#status_message').autofill({
	value: 'What are you up to?',
	defaultTextColor: '#666',
	activeTextColor: '#333'
});


// == Feeds
$('#feeds tbody').sortable({
	axis:'y',
	dropOnEmpty:false,
	update: function(){
		$.ajax({ data:$(this).sortable('serialize', {key:'feeds[]'}), dataType:'script', type:'post', url:'/admin/feeds/sort'
		});
	}
});

$(".feed .featured").each(function(){
  cell = $(this);
  if (cell.text() == 'true') {
    cell.parents("tr").addClass('featured');
  }
});

$('.feed_entry_header').click(function(){
	var $feedEntry = $(this).parent();
	$feedEntry.toggleClass('open');
	if (!$feedEntry.hasClass('read')) {
		$.post("/feed_entries/" + $feedEntry.attr('rel') + "/read", "_method=put", null);
		$feedEntry.addClass('read');
	}
	$feedEntry.find('.feed_entry_body').slideToggle(200);
});

$('.feed_entry .summary').hover(function(){
	$(this).addClass('hover');
}, function(){
	$(this).removeClass('hover');
}).click(function(){
	window.location = $(this).find('a').attr('href');
});

// == Inbox for RIA messages
$(".inbox_message .readit").click(function(){
  var $message = $(this).parents('.inbox_message');
  var messageId = $message.attr('id').match(/\d+$/g);
  $.post("/admin_messages/" + messageId + "/read", "_method=put", function(){
    $message.fadeOut(300, function(){
      $message.remove();
    });
  },null);  
  return false;
});

$('.direct_message .readit').click(function(){
  var $message = $(this).parents('.direct_message');
  var messageId = $message.attr('id').match(/\d+$/g);
  $.post("/direct_messages/" + messageId + "/read", "_method=put", function(){
    $message.fadeOut(300, function(){
      $message.remove();
    });
  },null);  
  return false;
});

// == Getting started box
if (window.current_user_id) {
  var $hideHelpBox = $('<div id="hide_help_box"/>');
  $("#get_started").append($hideHelpBox);
  $hideHelpBox.click(function(){
    $.post("/users/" + window.current_user_id, {
        _method: 'put',
        'user[preferred_hide_help_box]': '1'
      }, function(data){
         $hideHelpBox.parent().fadeOut();
      }, "js"
    );
  });
}


if (!typeof $.fn.tablesorter == 'undefined') {
$('.tablesorter').tablesorter({sortList: [[0,0]]});
}

