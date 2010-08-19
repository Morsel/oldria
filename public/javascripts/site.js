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


//
// Use this when you want a link to slidetoggle the element it's href points to:
//
//   <a href="#box">Toggles the element with id "box"</a>
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
      
      var text = link.text();
      if (link.hasClass('open')) {
        link.text(text.replace(/View/, 'Close'));
      } else {
        link.text(text.replace(/Close/, 'View'));
      }
      return false;
    });
  });
};

$(".showit").showy();

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
    .append('<a class="remove_attachment" href="javascript:void(0)">remove</a>')
    .after('<p class="add-another"><a href="javascript:void(0)">Add an attachment</a></p>')
    .next().find('a').click(smartCloneAttachment);

    // Cache this value for the smartCloneAttachment function
    addNewLink = $(".add-another");

    // Remove from DOM, but not memory
    $attachmentFieldPrototype.detach();

  });
};

$(".attachfield:first").attachmentCloner();

// == Hidden fieldsets
var fieldsets = $("div.fieldsets").hide();
var generalfields = $("#fields_for_general");
  generalfields.detach();

$("#media_request_request_types").bind('change', function(){
	fieldsets.hide();
	var _this = $(this);
	var val = _this.find(":selected").attr("value");
	if (val == ''){
		_this.after(generalfields);
		generalfields.fadeIn();
	} else {
		generalfields.detach();
		$("#fields_for_" + val).fadeIn();
	} 
}).change();


var calendarFields = fieldsets.find('input').filter(function(){
	return $(this).attr("id").match(/date/);
});

calendarFields.datepicker ({
	showAnim: 'fadeIn',
	constrainInput: false
});

$("#date-select #date").datepicker();

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

$("#employee_name").autocomplete("/users.js", {
	autoFill: true,
	max: 15
});

$("#restaurant_name").autocomplete("/restaurants.js", {
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
var dynamicalCheckAllBoxes = function(){
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
};

dynamicalCheckAllBoxes();


var $omniscientField = $("input#employment_omniscient"),
    $omniscientRoleCheckboxes = $('#employment_general_subject_matters :checkbox, #employment_subject_matters :checkbox');

var selectOmniscientRoles = function(){
  if($omniscientField.is(":checked")) {
    $omniscientRoleCheckboxes.disable();
    $omniscientRoleCheckboxes.attr('checked', 'checked');
  } else {
    $omniscientRoleCheckboxes.enable();
    $omniscientRoleCheckboxes.removeAttr('checked');
  }
};

$omniscientField.change(selectOmniscientRoles);

if($omniscientField.is(":checked")) { $omniscientField.change(); }

//Cufon
// if(typeof(Cufon) != 'undefined') {
// 	Cufon.replace('.function-bold', {fontFamily:'FunctionBold', hover:true});
// }

$('#status_message').autofill({
	value: 'What are you working on?',
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
$(".inbox_message .readit").live('click', function(){
  var $message = $(this).parents('.inbox_message');
  $.post(this.href, "_method=put", function(){
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


var sortedTables = $('.tablesorter');
if (sortedTables.length) {
  sortedTables.tablesorter({sortList: [[0,0]]});
}

// == Dynamic Updates for Employment Searching
var	$employmentsList  = $("#employment_list");
var $employmentInputs = $("#employment_criteria input[type=checkbox]");
var $loaderImg =        $('<img class="loader" src="/images/ajax-loader.gif" />').hide();

// load the image load indicator, hidden
$employmentsList.before($loaderImg);

function updateEmploymentsList() {
  $employmentInputs = $("#employment_criteria input[type=checkbox]");
	input_string = $employmentInputs.serialize();
	$loaderImg.show();
	$employmentsList.hide();
	$employmentsList.load('/employment_search', input_string, function(responseText, textStatus){
	  $loaderImg.hide();
	  $employmentsList.fadeIn(300);
	});
	// return true;	
}

$employmentInputs.live('change', updateEmploymentsList);

// Directory search
var	$directoryList  = $("#directory_list");
var $directoryInputs = $("#directory_search #employment_criteria input[type=checkbox]");

$directoryList.before($loaderImg);

function updateDirectoryList() {
	input_string = $directoryInputs.serialize();
	$loaderImg.show();
	$directoryList.hide();
	$directoryList.load('/directory/search', input_string, function(responseText, textStatus){
	  $loaderImg.hide();
	  $directoryList.fadeIn(300);
	});
	// return true;	
}

$directoryInputs.change(updateDirectoryList);

// == New User row highlight ==
if (location.hash && location.hash.match(/user_\d+$/)) {
  var userRowCells = $(location.hash).find('td');
  userRowCells.css({'background-color': '#ffff55'});
  userRowCells.animate({'background-color': '#ffffff'}, 700);
}

$('#criteria_accordion').accordion({
	autoHeight: false,
	collapsible: true,
	active: false,
	header: '.accordion_box a:first-child',
	change: function() {
		$('.accordion_box').each(function(){
			if($(this).find('input:checked').length > 0){
				$(this).find('a.ui-accordion-header').addClass('options_selected');
			} else {
				$(this).find('a.options_selected').removeClass('options_selected');
			}
		});
	}
}).find('.loading').removeClass('loading');


if (typeof($.fn.colorbox) != 'undefined') {
    $('.colorbox').colorbox({
        initialWidth: 420,
        maxWidth: 450
    });

    $('.close').live('click', function(){
        close_box();
    });

    $('#new_quick_reply button').live('click', function(){
        $(this).text('posting...');
    });

    function post_reply_text(){
        $('#new_quick_reply button').text('Post Reply');
    }

    function close_box(){
        $.fn.colorbox.close();
    }
}

// Using this assumes that you've "build" on an association to get new blank field(s)
$.fn.clonableField = function(options){
  var config = {};
  if(options) $.extend(config, options);
  
  return this.each(function(){
    var fieldsContainer = $(this);
    var fieldprototype = fieldsContainer.children(':last-child').detach();
    fieldprototype.find('input[type=hidden]').remove();
    var linkHolder = $('<p class="add-another"><a href="#" class="positive">Add Another</a></p>');
    var link = linkHolder.find('a.positive');

    link.click(function(){
      var newfield = fieldprototype.clone();
      newfield.find('input, textarea').each(function(){
        var field = $(this);
        var originalName = field.attr('name');
        var now = new Date().getTime();
        field.attr("name", originalName.replace(/(\d)/g, now)).attr('id', "");
      });
      linkHolder.before(newfield);
      return false;
    });

    fieldsContainer.append(linkHolder);
  });
};



$('.clonable_fields').clonableField();

function remove_fields() {
  var link = $(this);
  link.siblings("input.hidden_destroy").attr('value', '1');
  link.siblings(".input").hide();
  link.parent().hide();
  link.remove();
  return false;
}

$('a.remove_field').live('click', remove_fields);

function setupProfileProgressbar(selector) {
  var profile_progressbar = $(selector);
  if (profile_progressbar.length) {
    var percent = parseInt(profile_progressbar.siblings('.numeral').text(), 10);

    profile_progressbar.progressbar({
      value: percent
    });
  }  
}

setupProfileProgressbar('#profile_completeness_progressbar');


// Cleaning up email fields
$('#user_email').blur(function() {
  this.value = jQuery.trim(this.value);
});


$('.soapbox_sidebar').tabs();
$('.tabable').tabs();

// Profile question admin
$('#chapters tbody').sortable({
	axis:'y',
	dropOnEmpty:false,
	update: function(){
		$.ajax({ data:$(this).sortable('serialize', { key: 'chapters[]' }), dataType:'script', type:'post', url:'/admin/profile_questions/sort'
		});
	}
});

$('#profile_questions tbody').sortable({
	axis:'y',
	dropOnEmpty:false,
	update: function(){
    var postData = $(this).sortable('serialize', { key: 'profile_questions[]' });
    postData = postData + "&chapter_id=" + $(".chapter").attr("id").split("_")[1];
		$.ajax({ data: postData,
		    dataType:'script', type:'post', url:'/admin/profile_questions/sort'
		});
	}
});

$('#topics tbody').sortable({
	axis:'y',
	dropOnEmpty:false,
	update: function(){
		$.ajax({ data:$(this).sortable('serialize', { key: 'topics[]' }), dataType:'script', type:'post', url:'/admin/profile_questions/sort'
		});
	}
});

// Admin page row highlighting

$(function() {
  $(".admin_backend #pages " + window.location.hash + " td").effect("highlight", {}, 3000);
});
