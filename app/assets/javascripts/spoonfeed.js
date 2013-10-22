$(document).ready(function(){
  
  $('a.disable_link').click(function(e){
      e.preventDefault();
      $('#flashes').html("<div id='flash_notice'>Looks like the "+$('#profileDetails h2').text()+" restaurant profile is missing some personnel! Please add all key staff to the staff tab to ensure the restaurant is accurately represented for media so you can proceed. Thank you!</div>");
      $('html, body').animate({scrollTop: $('#flashes').offset().top -50}, 400)
  });


  $('div.add_answer').on('click',function(e){    
    $(this).next().slideToggle('slow',function(){
      $(".restaurant_answers").not(this).hide()
      $('html, body').animate({scrollTop: $(this).prev().offset().top-80}, 400)
    })

  });

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
  } else{
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
    beforeSubmit:function(){
      $form.hide();
      $('#cboxLoadingGraphic').show(); 
    },
    success: function(text){
      $('#cboxLoadingGraphic').hide(); 
      if($form.attr('id')== "create_employment_form")
      {
       
        $.fn.colorbox.close();
        $(location).attr('href',text.url);
      }  
        var $html = $(text.html);
        var $id   = $html.attr('id');
        var singularName = $id.replace(/^new_/, "").replace(/_\d+$/, "");
        var existingElement = $('#'+ $id);
        if (existingElement.length) {
          existingElement.html($html.html());
        } else {
          $("#" + singularName + "s").append($html);
        }
        showResponse(text)      
        $.fn.colorbox.close();
    },
    error: function(xhr, status){
      var response;
      try { response = $(xhr.responseText); } catch(e) { response = xhr.responseText; }

      $.colorbox({html: response,onClosed:function(){
        if($form.attr('id')=="new_profile_cuisine")
        {
          $('#step3').slideDown();
          loderHide()
        }
      }});
      if($form.attr('id')=="create_employment_form")
        $.colorbox({html: response,overlayClose: false,escKey:false});
      else  
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

$('#colorbox form.stage, #colorbox form.apprenticeship, #colorbox form.nonculinary_enrollment, #colorbox form.award, #colorbox form.culinary_job, #colorbox form.nonculinary_job, #colorbox form.accolade, #colorbox form.enrollment, #colorbox form.competition, #colorbox form.internship, #colorbox form.james_beard_region').live('submit', colorboxForm);
$('#complete_profile form.profile_cuisine').live('submit', colorboxForm);
$("#create_employment_form").live('submit', colorboxForm);
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
var $employmentsList  = $("#employment_list");
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
var $loaderImg = $('<img class="loader" src="/images/ajax-loader.gif" />').hide();
var $directoryList = $("#user_directory_list");
var $directoryInputs;
//var $directoryInputs = $("#directory_search #employment_criteria input[type=checkbox]");

$directoryList.before($loaderImg);

$.fn.updateDirectoryList = function() {
  input_string = $directoryInputs.serialize();
  $loaderImg.show();
  $directoryList.hide();
  $directoryList.load('/directory/search_user', input_string, function(responseText, textStatus){
    $loaderImg.hide();
    $directoryList.fadeIn(300);
  });
// return true;
}
// personal directory search button event
$("#person_by_any_name").click(function(){
  $directoryInputs = $("#directory_search #person_criteria #search_person_eq_any_name");
  $.fn.updateDirectoryList();
});
$("#person_by_state_region").click(function(){
  $directoryInputs = $("#directory_search #person_criteria #search_person_by_state_or_region");
  $.fn.updateDirectoryList();
});
//$directoryInputs.change(updateDirectoryList);


// Restaurant directory search
var $restoDirectoryList = $("#restaurant_directory_list");
// var $restoDirectoryInputs = $("#directory_search #restaurant_criteria #restaurant_search");
var $restoDirectoryInputs;
$restoDirectoryList.before($loaderImg);

$.fn.updateRestoDirectoryList = function() {
  input_string = $restoDirectoryInputs.serialize();
  $loaderImg.show();
  $restoDirectoryList.hide();
  $restoDirectoryList.load('/directory/search_restaurant_by_name', input_string, function(responseText, textStatus){
    $loaderImg.hide();
    $restoDirectoryList.fadeIn(300);
  });
  // return true;
};

// Restaurant directory search button event
$("#restaurant_by_any_name").click(function(){
  $restoDirectoryInputs = $("#directory_search #restaurant_criteria #search_restaurant_eq_any_name");
  $.fn.updateRestoDirectoryList();
});
$("#restaurant_by_state_region").click(function(){
  $restoDirectoryInputs = $("#directory_search #restaurant_criteria #search_restaurant_by_state_or_region");
  $.fn.updateRestoDirectoryList();
});


//
// Managing subject matters for restaurant managers
var $omniscientField = $("input#employment_omniscient,input#employment_edit_privilege");
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

$("#otm_keyword_search").autocomplete({
  source: "/otm_keywords.js",
});
 
$('.search-button').click(function(e){
  e.preventDefault();
  var $form=$(this).parent().find("input:text");
    $('#restaurant_criteria input').not($form).val('');
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
$('#metropolitan_areas_state_state_id,#digest_metropolitan_areas_state_state_id').change(function(){

   $(this).next().html($('<img />').attr({'src': '/images/redesign/ajax-loader.gif', 'alt': 'Lodding...' }));
   $this = $(this)
   var user_id = $('#user_id').val()
    if($(this).val())
        $.ajax({
    data:'state_name=' + encodeURIComponent($(this).val()) +(user_id ? ('&user_id=' +user_id) : ''),
        success:function(response){
          $this.next().html(response)
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

    /* Profile complete wizard*/
    $('#profile-summary').show();

    var options = {         
        success:   showResponse,  // post-submit callback 
        dataType: 'json'
    };

    $('#form_upload_img').submit(function(e) { 
        e.preventDefault();        
        current_page_id =  $(this).parent().attr('id')   
        next_page_id    =  $(this).parent().next().attr('id')   
        loderShow();
        $(this).ajaxSubmit(options); 
        return false; 
    });
    $('#specialties_form').submit(function(e) { 

        e.preventDefault();
        current_page_id =  $(this).parent().attr('id')   
        next_page_id    =  $(this).parent().next().attr('id') 
        loderShow()

        $(this).ajaxSubmit(options); 
        return false; 
    });
    $('#complete_profile form.profile_cuisine').live('submit', function(e) { 
        e.preventDefault();
        if($('#redirect_to_url_hidden').val()){
              current_page_id =  $('#cuisine_form').parent().attr('id')   
              next_page_id    =  $('#cuisine_form').parent().next().attr('id') 
              loderShow()
        }
       
        return false; 
    });
     $('#cuisine_form').submit(function(e) { 

        e.preventDefault();
        current_page_id =  $(this).parent().attr('id')   
        next_page_id    =  $(this).parent().next().attr('id') 
        loderShow()

        $(this).ajaxSubmit(options); 
        return false; 
    });

   $('.add-btl').colorbox({rel:'gal'});
  var cache = {};
  $( "#user_default_employment_attributes_solo_restaurant_name" ).autocomplete({
      minLength: 2,
      source:function( request, response ) {
          var term = request.term;
          if ( term in cache ) {
              response( cache[ term ] );
              return;
          }
          $.getJSON( "/complete_registration/find_restaurant", { restaurant_name: request.term }, function( data, status, xhr ) {
              cache[ term ] = data;
              response( data );
          });
      }

    });

  $("#newsfeed_james_beard_regions_input input[type=checkbox]").click(function(){
    if($("#newsfeed_james_beard_regions_input input:checkbox:checked").length>0)


    {
      $("#regional_newsfeed_promotion_type").show('slow')
    }else
    {
      $("#regional_newsfeed_promotion_type").hide('slow')
    }

  })

  $("#user_newsfeed_writer_id").change(function(){

      
      $("#metropolitan_areas_state_cities").html("")
      $("#metropolitan_areas_state_state_id option[value='']").attr("selected", "selected");
      if($(this).val() == "")
      {
        $('#newsfeed_option_national').hide('slow')
        $('#newsfeed_option_regional').hide('slow')
        $('#newsfeed_option_locals').hide('slow')

        

      }else{
        if($(this).val()==1)
        {
          $('#newsfeed_option_national').show('slow')
          $('#newsfeed_option_regional').hide('slow')
          $('#newsfeed_option_locals').hide('slow')

        }        
        else if($(this).val()==2)
          {
            $('#newsfeed_option_regional').show('slow')
            $('#newsfeed_option_national').hide('slow')
            $('#newsfeed_option_locals').hide('slow')

          }
        else if($(this).val()==3)
        {
          $('#newsfeed_option_national').hide('slow')          
          $('#newsfeed_option_regional').hide('slow')
          $('#newsfeed_option_locals').show('slow')
        }
      }

    })



    $("#user_digest_writer_id").change(function(e){


      $("#digest_metropolitan_areas_state_cities").html("")
      $("#digest_metropolitan_areas_state_state_id option[value='']").attr("selected", "selected");
      if($(this).val() == "")
      {
        $('#digest_option_national').hide('slow')
        $('#digest_option_regional').hide('slow')
        $('#digest_option_locals').hide('slow')

        

      }else{
        if($(this).val()==1)
        {
          $('#digest_option_national').show('slow')
          $('#digest_option_regional').hide('slow')
          $('#digest_option_locals').hide('slow')


        }        
        else if($(this).val()==2)
          {
            $('#digest_option_regional').show('slow')
            $('#digest_option_national').hide('slow')
            $('#digest_option_locals').hide('slow')
          }
        else if($(this).val()==3)
        {
          $('#digest_option_national').hide('slow')          
          $('#digest_option_regional').hide('slow')
          $('#digest_option_locals').show('slow')

        }
      }

    })


  $('#newsfeed_option_locals input[type=checkbox], #user_metropolitan_areas_input input[type=checkbox], #newsfeed_option_national_input input[type=checkbox], #newsfeed_option_regional input[type=checkbox], #digest_james_beard_regions_input input[type=checkbox]').click(function(){
    if($(this).prop('checked'))
      $(this).prev().removeAttr("disabled");
    else
      $(this).prev().attr("disabled","disabled");
  })

 $('#add_more').click(function(e){
    e.preventDefault();
    more_people = $('#more_people').clone();
    $('#more_people').show();
    $(".recommendation_invitations .name").each(function() {
        $(this).removeClass('name');
        $(this).addClass('first_name');
    });
    $(".recommendation_invitations .last").each(function() {
        $(this).removeClass('last');
        $(this).addClass('last_name');
    });
    $(".recommendation_invitations .email").each(function() {
        $(this).removeClass('email');
        $(this).addClass('email_id');
    });
    more_people.insertAfter('#more_people');

  });
  $('#recommendation_invitations').click(function(e){
    e.preventDefault(); 
    var ret_val=""
    var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
    $(".recommendation_invitations .first_name").each(function() {
      if($(this).val()==""){
        ret_val='Please enter the first name<br/>';
        return false
      }
    });
    $(".recommendation_invitations .last_name").each(function() {
        if($(this).val()==""){
        ret_val=ret_val+'Please enter the last name<br/>';
        return false
      }
    });
    $(".recommendation_invitations .email_id").each(function() {
       if($(this).val()=="" || !pattern.test($(this).val()) ){
        ret_val=ret_val+'Please enter the valid email id<br/>';
        return false
      }
    });    
    if (ret_val.length==0){
      $("#form_invitation").submit();
    }else{
      $('#flashes').html('<div id="flash_error">'+ret_val+'</div>');
    }
  });

  $('.search-button').click(function(){
    var $form=$(this).parent().find("input:text");
    $('#restaurant_criteria input').not($form).val('');
  });
  // //mediafeed user edit 
  $("#search_state_by_name").autocomplete({
    source: "/auto_complete.js?metro=metro",
    select: function( event, ui ) {
      $('#loader').html($('<img />').attr({'src': '/images/redesign/ajax-loader.gif', 'alt': 'Lodding...' }));
      var selected_city = new Array();    
      $("#newsfeed_metropolitan_area_search input[type=checkbox]").each(function(){
           if ($(this).is(":checked")){
              selected_city.push($(this).val());            
          }  
      })
      $.ajax({
        data:'state_name=' +ui.item.value+'&user_id='+$('#user_id').val()+'&checked_city='+selected_city,           
        url:'/mediafeed/media_users/get_selected_cities?newsfeed=newsfeed',
        success:function(request,response){
          $('#search_state_by_name').val('');
        }
      });
    }
  });
  $("#search_digest_state_by_name").autocomplete({
    source: "/auto_complete.js?metro=metro",
    select: function( event, ui ) {
      $('#digest_loader').html($('<img />').attr({'src': '/images/redesign/ajax-loader.gif', 'alt': 'Lodding...' }));
      var selected_city = new Array();    
      $("#digest_metropolitan_area_search input[type=checkbox]").each(function(){
           if ($(this).is(":checked")){
              selected_city.push($(this).val());            
          }  
      })
      $.ajax({
        data:'state_name=' +ui.item.value+'&user_id='+$('#user_id').val()+'&checked_city='+selected_city,           
        url:'/mediafeed/media_users/get_selected_cities?test=test',
        success:function(request,response){
          $('#search_digest_state_by_name').val('');
        }
      });
    }
  });
  $("#newsfeed_metropolitan_area_search input[type=checkbox], #digest_metropolitan_area_search input[type=checkbox]").live('click',function() {
    if($(this).prop('checked'))
      $(this).prev().removeAttr("disabled");
    else
      $(this).prev().attr("disabled","disabled");
  });
  // end mediafeed user edit 
  $('.skipp').live('click',function(e){
      e.preventDefault();
      $(this).closest('form').submit();      
   })
    
  var sortedTables = $('.tablesorter');
  if (sortedTables.length) {
    sortedTables.tablesorter({sortList: [[0,0]]});
  }  
  // end $(document).ready
});

  var current_page_id ;
  var next_page_id ;
// post-submit callback 
function showResponse(responseText, statusText, xhr, $form)  { 
      loderHide();      
      if(responseText.status)
      {
        if(next_page_id != "loader-waiting")      
          $('#'+next_page_id).slideDown(); 
        else
          location.href = $('#redirect_to_url_hidden').val();
      }  
      else
      {
        loderHide();
        if(current_page_id == "step1")
        {
          $('#user_avatar_input').addClass('error');
          $('#user_avatar_input p').remove();
          $.each(responseText.errors, function(index, value) { 
            $('#user_avatar_input').append('<p>'+value[1]+'</p>');
          });

          
        }
         $('#'+current_page_id).slideDown();
      }
        
  } 
function loderShow()
{
  $('#'+current_page_id).slideUp();
  $('#loader-waiting').slideDown();
}
function loderHide()
{
  $('#loader-waiting').slideUp();
}