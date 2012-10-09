$(document).ready(function(){

$('<span class="down-arrow"></span>').appendTo('a.selected');

$('.footerBox').equalHeights();
$('.hp_promo').equalHeights();
$('.chapter').equalHeights();
$('.topic').equalHeights();
$('.rest_staff .employment').equalHeights();
$('#newsfeed .promotion').equalHeights();

$('#extended_profile .equalheights').equalHeights(160);

$('#front-burner-comments #new_comment').submit(function(){
    $(":button", this).attr('disabled', 'disabled');
    $('#comment_comment').hide();
    $('#loading-wait').show();
});

$('#btl_answers form').submit(function(){
    $(":button", this).attr('disabled', 'disabled');
    $('.text').hide();
    $('#loading-wait').show();
});

jQuery('.standard-filler').formFiller();

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

$('#profile_user_attributes_publish_profile').live('click',function(){
	if(!$(this).is(':checked')){
		return;
	}
	answer = confirm('Are you sure? Is your profile filled out yet?\n\nMake sure your profile is filled out a good amount before sharing it with the public!');
	if (answer){
		$(this).attr('checked','checked');
	}	else{
		$(this).removeAttr('checked');
	}
})

$('#open-profile-summary').click(function(){
	$('#profile-tabs').tabs('select',1);
})

$('.tabable').tabs({
	panelTemplate: '<section></section>',
	fx: { duration: 'fast', opacity: 'toggle' }
});


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

$('.new_question').live('click', function(){
    $(this).css({
		backgroundRepeat: 'no-repeat',
		backgroundPosition: 'center center',
		backgroundImage: 'url(/images/redesign/ajax-loader.gif)'
	});
	$.ajax({
		data:'authenticity_token=' + encodeURIComponent($(this).attr('data-auth')),
	 	success:function(request){
			$('#btl_game_content').html(request);
			$('.new_question').css({
				backgroundImage: 'url(/images/redesign/icon-refresh.png)',
				backgroundPosition: '0 0'
			})
		},
		type:'post',
		url:'/users/'+$(this).attr('data-user-id')+'/questions/refresh'
	});
	return false;
});

$('#profile_answer_submit').live('click', function(){
    var rthis = this;
    setTimeout(function(){
        $(rthis).val('posting...').attr('disabled','disabled');
    }, 0);
});

$('#new_quick_reply button').live('click', function(){
	$(this).text('posting...').attr('disabled','disabled');
});

function jumbotronController(idx, elem){
	idx++;
	return html+='<a href="#">'+idx+'</a>';
}

var colorboxOnComplete = function(){
  $('#school_fields').toggle();
  $('#culinary_job_chef_is_me').click(function(){
    var nameField = $('#culinary_job_chef_name');
    var $this     = $(this);
    if ($this.is(":checked")) {
      nameField.val($(this).attr('rel'));
    } else {
      nameField.val('');
    }
  });
};

// Search filter UI
$('#criteria_accordion').accordion({
  autoHeight: false,
  collapsible: true,
  active: false,
  header: '.accordion_box a',
  change: function() {
    $('.accordion_box').each(function(){
      if($(this).find('input:checked').length > 0){
        $(this).find('a').addClass('options_selected');
      } else {
        $(this).find('a').removeClass('options_selected');
      }
    });
  }
}).find('.loading').removeClass('loading');

$.fn.ajaxDestroyLink = function(options){
  var config = {
    confirmMessage: "Are you sure you want to PERMANENTLY delete this?",
    containerSelector: 'tr:first'
  };

  if(options) { $.extend(config, options); }

  return $(this).each(function(){
    var $this = $(this);
    $this.removeAttr('onclick');
    $this.unbind();
    $this.live('click',function(){
      if (confirm(config.confirmMessage)) {
        $.post(this.href+".js", {_method: 'delete'}, function(data, status){
          var container = $this.parents(config.containerSelector);
          container.fadeOut(200,function(){
            container.remove();
          });
        });
      }
      return false;
    });
  });
};

var bindAjaxDeleters = function(){
  $('#profile-tabs a.delete').ajaxDestroyLink({
    containerSelector: 'li:first'
  });
};

bindAjaxDeleters();

var colorboxForm = function(){
  var $form = $(this);
  // var button = $form.find('button:first');
  // button.disable();
  $form.ajaxSubmit({
    dataType: 'json',
    url: $form.attr('action') + '.json',
    success: function(text){
      var $html = $(text.html);
      var $id   = $html.attr('id');
      var singularName = $id.replace(/^new_/, "").replace(/_\d+$/, "");
      var existingElement = $('#'+ $id);
      if (existingElement.length) {
        existingElement.html($html.html());
      } else {
        $("#" + singularName + "s").append($html);
      }
      $.fn.colorbox.close();
    },
    error: function(xhr, status){
      var response;
      try { response = $(xhr.responseText); } catch(e) { response = xhr.responseText; }
      $.colorbox({html: response});
    }
  });
  // button.enable();

  return false;
};

var bindColorbox = function() {
  $('.colorbox').colorbox({
    initialWidth: 450,
    onComplete: colorboxOnComplete,
    current: '',
    onClosed: function() {
      bindAjaxDeleters();
      bindColorbox();
    }
  });
};

function close_box(){
  $.fn.colorbox.close();
}

$('.close').live('click', close_box);

function post_reply_text(){
  $('#new_quick_reply button').text('Post Reply');
}

// Do it!
bindColorbox();

$('#colorbox form.stage, #colorbox form.apprenticeship, #colorbox form.nonculinary_enrollment, #colorbox form.award, #colorbox form.culinary_job, #colorbox form.nonculinary_job, #colorbox form.accolade, #colorbox form.enrollment, #colorbox form.competition, #colorbox form.internship').live('submit', colorboxForm);

$("a.showit").showy();


// Update top tags remaining on load
var max = 15;
var remaining = max-$('#restaurant_tags input:checkbox:checked').length;
$('#tags_remaining').html(remaining+" left");
if (remaining == 0) {
  $('#restaurant_tags input:checkbox').not(':checked').attr('disabled', true).next('label').css('color', 'gray');
}

$('#restaurant_tags input:checkbox').click(function() {
  var $checkbox = $('#restaurant_tags input:checkbox');
  var total = $(":checkbox:checked").length;
  var remaining = (max-total) + " left";
  if (total < max) { // Update counter.
    $('#tags_remaining').html(remaining);
    $checkbox.removeAttr('disabled');
    $checkbox.next('label').css('color', '#333');
  } else { // Disable all checkboxes
      $('#tags_remaining').html(remaining);
      $checkbox.not(':checked').attr('disabled', true).next('label').css('color', 'gray');
  }
});
// Enable all the checkboxes on submit
$('#restaurant_tags form').submit(function() {
  $('#restaurant_tags form:checkbox').not(':checked').removeAttr('disabled');
});

// == Dynamic Updates for Employment Searching
var	$employmentsList  = $("#employment_list");
var $employmentInputs = $("#employment_criteria input[type=checkbox]");
var $loaderImg        = $('<img class="loader" src="/images/ajax-loader.gif" />').hide();

// load the image load indicator, hidden
$employmentsList.before($loaderImg);

updateEmploymentsList = function() {
  input_string = $employmentInputs.serialize();
  $loaderImg.show();
  $employmentsList.hide();
  $employmentsList.load('/employment_search', input_string, function(responseText, textStatus){
    $loaderImg.hide();
    $employmentsList.fadeIn(300);
  });
  // return true;
};

$employmentInputs.change(updateEmploymentsList);


// Directory search
var	$directoryList  = $("#directory_list");
var $directoryInputs = $("#directory_search #employment_criteria input[type=checkbox]");

$directoryList.before($loaderImg);

updateDirectoryList = function() {
  input_string = $directoryInputs.serialize();
  $loaderImg.show();
  $directoryList.hide();
  $directoryList.load('/directory/search', input_string, function(responseText, textStatus){
    $loaderImg.hide();
    $directoryList.fadeIn(300);
  });
  // return true;
};

$directoryInputs.change(updateDirectoryList);


// Restaurant directory search
var	$restoDirectoryList  = $("#restaurant_directory_list");
var $restoDirectoryInputs = $("#directory_search #restaurant_criteria input[type=checkbox]");

$restoDirectoryList.before($loaderImg);

updateRestoDirectoryList = function() {
  input_string = $restoDirectoryInputs.serialize();
  $loaderImg.show();
  $restoDirectoryList.hide();
  $restoDirectoryList.load('/directory/restaurant_search', input_string, function(responseText, textStatus){
    $loaderImg.hide();
    $restoDirectoryList.fadeIn(300);
  });
  // return true;
};

$restoDirectoryInputs.change(updateRestoDirectoryList);


//
// Managing subject matters for restaurant managers
var $omniscientField = $("input#employment_omniscient");
var $omniscientRoleCheckboxes = $('#employment_general_subject_matters :checkbox, #employment_subject_matters :checkbox');

var selectOmniscientRoles = function(){
  if($omniscientField.is(":checked")) {
    $omniscientRoleCheckboxes.attr('checked', 'checked');
    $omniscientRoleCheckboxes.attr('disabled', 'disabled')
  } else {
    $omniscientRoleCheckboxes.removeAttr('checked');
    $omniscientRoleCheckboxes.removeAttr('disabled');
  }
};

$omniscientField.change(selectOmniscientRoles);

if($omniscientField.is(":checked")) { $omniscientField.change(); }

// == Media request fields - subject matters
var fieldsets = $("div.media_request_subject").hide();
var generalfields = $("#fields_for_general");
generalfields.detach();

$("#media_request_request_types").bind('change', function(){
    fieldsets.hide();
    var _this = $(this);
    var val = _this.find(":selected").attr("value");
    if (val === ''){
        _this.after(generalfields);
        generalfields.fadeIn();
    } else {
        generalfields.detach();
        $("#fields_for_" + val).fadeIn();
    }
}).change();

// Media request recipient list
$('.show_more').click(function(){
	toggle_me_first = $(this).attr('href');
	toggle_me_next = $(this).attr('data-show');
	$(toggle_me_first).toggle();
	$(toggle_me_next).toggle();
	return false;
})

$('div#photos').masonry({
    columnWidth: 200,
    itemSelector: '.photo'
});

updateRestaurantSignupFields = function() {
  if ($('#role').val() == 'restaurant') {
    $('#restaurant_fields').show();
  } else {
    $('#restaurant_fields').hide();
  }
};

$("#user_editor").autocomplete({
	source: "/users.js",
});

// Social updates filtering
var $restoSocialList   = $("#updates");
var $restoSocialInputs = $("#restaurant_filters #restaurant_criteria input[type=checkbox]");
var $socialLoaderImg   = $('#loading').hide();

$restoSocialList.before($socialLoaderImg);

updateRestoDirectoryList = function() {
  input_string = $restoSocialInputs.serialize();
  $socialLoaderImg.show();
  $restoSocialList.hide();
  $restoSocialList.load('/filter_social', input_string, function(responseText, textStatus){
    $socialLoaderImg.hide();
    $restoSocialList.fadeIn(300);
  });
  // return true;
};

$restoSocialInputs.change(updateRestoDirectoryList);

// get cities list by state name : Nishant
$('#metropolitan_areas_state_state_id').change(function(){

   $('#metropolitan_areas_state_cities').html($('<img />').attr({'src': '/images/redesign/ajax-loader.gif', 'alt': 'Lodding...' }));

    if($(this).val())
        $.ajax({
		data:'state_name=' + encodeURIComponent($(this).val()),
	     	success:function(response){
			    $('#metropolitan_areas_state_cities').html(response)
		    },
		url:'/mediafeed/get_cities'
	    });


})
  $('.restaurants-model').click(function(e){
    e.preventDefault();
    var id = $(this).attr('id')
    $.colorbox({href:"/directory/current_user_restaurants?clicked="+id});   

  })/* End model click*/

  $('#select_restaurant').live('change',function(){    
    if($(this).val())
    {
      $('#color-box-restaurant-msg').show();
      $('#color-box-restaurant').hide();

      $.ajax({
          type: 'POST',
          url: ' /directory/get_restaurant_url',
          data: "restaurant_id="+$(this).val()+"&clicked_page="+$('#hidden_clicked_nav').val(),
          success: function(data){
            if(data.url)
              $(location).attr('href',data.url);
            else
            {
              $('#color-box-restaurant').show()
              $('#color-box-restaurant-msg').hide();
             }
          },
          dataType: 'json'
        });
    }
  }) /*End select_restaurant onchange*/



   $('.add-btl').colorbox({rel:'gal'});

  // end $(document).ready
});

