$(document).ready(function(){
	
	$('#restaurant_directory_list .identity').equalHeights();
	$('#directory_list .identity').equalHeights();
	$('.culinary').equalHeights();
	$('.nonculinary_job').equalHeights();
	$('.award').equalHeights();
	$('.accolade').equalHeights();
	$('.enrollment').equalHeights();
	$('.competition').equalHeights();
	$('.internship').equalHeights();
	$('.stage').equalHeights();
	$('.apprenticeship').equalHeights();
	$('.rest_staff .employment').equalHeights();
	
	if($('#recent-activity').length > 0){
	
		$('#recent-activity').tabs({
			panelTemplate: '<ol></ol>',
			fx: { duration: 'fast', opacity: 'toggle' }
		});
		$('#recent-activity ol').equalHeights();
		
		if($('#sidebar').height() > $('#inside').not('.home').height()){
			$('#inside').not('.home').css('min-height', $('#sidebar').height() + 50 + 'px');
		}
	}
	
	if($('#content.home .panel').length > 1){
		$('#content.home .panel').equalHeights();
	}
	
	$('.colorbox').colorbox({
			current: ''
  });

	$('div#photos').masonry({ 
		columnWidth: 330,
		itemSelector: '.photo'
	});

	
	if($('#cycle').length > 0){
		$('#cycle').cycle({
			timeout: 8000,
			fx: 'uncover',
			easing: 'easeInOutCubic',
			pager: '#pager',
			pagerAnchorBuilder: buildPager,
			after: displayInfo
		});
	}
	
	if($('#criteria_accordion').length > 0){
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
	}
	
	$('.showit').showy();
	$('.tabable').tabs({
		panelTemplate: '<ol></ol>',
		fx: { duration: 'fast', opacity: 'toggle' }
	});
	$('.ui-tabs-panel').equalHeights();

	$('#trend-comments .comment, #qotd-comments .comment').equalHeights();
	
//for autocomplete controller
	$("#user_search").autocomplete({
	  source: "/users.js",
	});  

  $('.search-button').click(function(e){
   e.preventDefault();
   var $form=$(this).parent().find("input:text");
    $('#restaurant_criteria input').not($form).val('');
  });

    $("#newsletter_subscriber_digest_diner_id").change(function(e){


      $("#digest_metropolitan_areas_state_cities").html("")
      $("#digest_metropolitan_areas_state_state_id option[value='']").attr("selected", "selected");
      if($(this).val() == "")
      {
        $('#digest_option_national').hide('slow')
        $('#digest_option_regional').hide('slow')
        $('#digest_option_locals').hide('slow')
        $("#subscriptions").css("height","408px")     
			}else{
        if($(this).val()==1)
        {
          $('#digest_option_national').show('slow')
          $('#digest_option_regional').hide('slow')
          $('#digest_option_locals').hide('slow')
          $("#subscriptions").css("height","408px")
        }        
        else if($(this).val()==2)
          {
            $('#digest_option_regional').show('slow')            
            $('#digest_option_national').hide('slow')
            $('#digest_option_locals').hide('slow')
            $("#subscriptions").css("height","505px")
          }
        else if($(this).val()==3)
        {
          $('#digest_option_national').hide('slow')          
          $('#digest_option_regional').hide('slow')
          $('#digest_option_locals').show('slow')
          $("#subscriptions").css("height",(590+$("#digest_metropolitan_area_search input[type=checkbox]").length)+"px")
        }
      }

    });

  $("#search_digest_state_by_name").autocomplete({
    source: "/soapbox?metro=metro",
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
          $("#subscriptions").css("height",(590+$("#digest_metropolitan_area_search input[type=checkbox]").length)+"px")
        }
      });
    }
  });  
  $("#digest_option_regional input[type=checkbox], #digest_metropolitan_area_search input[type=checkbox]").live('click',function() {
    if($(this).prop('checked'))
      $(this).prev().removeAttr("disabled");
    else
      $(this).prev().attr("disabled","disabled");
  });

}); // end document ready

function buildPager(idx, elem){
	idx++;
	return '<a href="#">'+idx+'</a>';
}

function displayInfo(currSlideElement, nextSlideElement, options, forwardFlag){
	title = $(nextSlideElement).attr('data-title');
	caption = $(nextSlideElement).attr('data-caption');
	url = $(nextSlideElement).attr('data-url');
	credit = 'Photo Credit: ' + $(nextSlideElement).attr('data-credit');
	link = url.length > 0 ? '&nbsp;<a href="' + url + '">go&nbsp;&#187;</a>' : '';
	$('#cycle-title').html(title);
	$('#cycle-footer').html(credit);
	$('#cycle-caption').html(caption + link);
}

// Directory search
var $loaderImg       = $('<img class="loader" src="/images/ajax-loader.gif" />').hide();
var	$directoryList   = $("#user_directory_list");
var $directoryInputs;
//var $directoryInputs = $("#directory_search #employment_criteria input[type=checkbox]");

$directoryList.before($loaderImg);

$.fn.updateDirectoryList = function() {
	input_string = $directoryInputs.serialize();
	$loaderImg.show();
	$directoryList.hide();
	$directoryList.load('/soapbox/directory_search?soapbox=soapbox', input_string, function(responseText, textStatus){
	  $loaderImg.hide();
	  $directoryList.fadeIn(300);
	});
	// return true;	
}
// Restaurant directory search button event
$("#person_by_any_name").click(function(){
  $directoryInputs = $("#directory_search #person_criteria #search_person_eq_any_name");
  $.fn.updateDirectoryList();
});
$("#person_by_state_region").click(function(){
  $directoryInputs = $("#directory_search #person_criteria #search_person_by_state_or_region");
  $.fn.updateDirectoryList();
});
//$directoryInputs.change(updateDirectoryList);

function show_all_questions_linker() {
	tabs = $('#sidebar').tabs();
	$('#view-all-questions').attr('href', SOAPBOX_ENTRIES_URLS[tabs.tabs('option', 'selected')]);
	return true;
}

// Restaurant directory search
var $restoDirectoryList = $("#restaurant_directory_list");
var $restoDirectoryInputs;
$restoDirectoryList.before($loaderImg);

$.fn.updateRestoDirectoryList = function() {
  input_string = $restoDirectoryInputs.serialize();
  $loaderImg.show();
  $restoDirectoryList.hide();
  $restoDirectoryList.load('/soapbox/restaurant_search', input_string, function(responseText, textStatus){
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

$("#user_editor").autocomplete({
  source: "/users.js",
});
$("#otm_keyword_search").autocomplete({
  source: "/otm_keywords.js",
});

$("#user_search").autocomplete({
  source: "/users.js",
});
$("#restaurant_search").autocomplete({
  source: "/restaurants.js",
});
$("#feature_search").autocomplete({
  source: "/features.js",
});
$("#state_search").autocomplete({
  source: "/states.js",
});
$("#specialty_search").autocomplete({
  source: "/specialties.js",
});
$("#region_search").autocomplete({
  source: "/james_beard_regions.js",
});
$("#state_search_for_user").autocomplete({
  source: "/metropolitan_areas.js",
});
$("#cusine_search").autocomplete({
  source: "/cuisines.js",
});