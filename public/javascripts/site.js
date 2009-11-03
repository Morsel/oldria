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

$('a.delete, a.trash').removeAttr('onclick');


// Hide the filter form by default on Admin search

$("#filter").hide();

$("a.showtarget").click(function(){
	$(this.hash).slideToggle('fast');
	return false;
});



// Show Current State indicators

$("#navigation a[href$=" + window.location.pathname + "]").parent().addClass("selected");


// == Comment attachments

$(".attachfield:first").after('<p class="add-another"><a href="#">Add another attachment</a></p>').next().click(function(){
	var oldfield = $(".attachfield:last");
	var newfield = oldfield.clone();
	var fieldname = newfield.find("input").attr("name");
	var number = parseInt(fieldname.match(/(\d)/), 10);
	newfield.find("input").attr("name", fieldname.replace(/(\d)/g, number+1)).attr('id', "");
	newfield.insertAfter(oldfield);
	return false;
});


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

var $employeeInput = $("#employment_employee_name");
var employeeFormAction = $employeeInput.parents("form").attr("action");
$employeeInput.autocomplete(employeeFormAction +".js", {
	autoFill: true,
	max: 15
});


