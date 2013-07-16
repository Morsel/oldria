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
  //for autocomplete controller
  $("#otm_keyword_search").autocomplete({
    source: "/auto_complete.js?name=otm",
  });
  $("#restaurant_search").autocomplete({
    source: "/auto_complete.js?name=restaurant",
  });
  $("#feature_search").autocomplete({
    source: "/auto_complete.js?name=feature",
  });
  $("#state_search").autocomplete({
    source: "/auto_complete.js?name=state",
  });
  $("#region_search_restaurant").autocomplete({
    source: "/auto_complete.js?name=region",
  });
  $("#cuisine_search_restaurant").autocomplete({
    source: "/auto_complete.js?name=cuisine",
  });
	
  $('.search-button').click(function(){
    var $form=$(this).prev().find('input:text')
    $('#restaurant_criteria input:text').each(function(){
		if ($(this).val()!=$form.val())
			$(this).val('');
	});    	
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
var	$directoryList   = $("#directory_list");
var $directoryInputs = $("#directory_search #employment_criteria input[type=checkbox]");

$directoryList.before($loaderImg);

function updateDirectoryList() {
	input_string = $directoryInputs.serialize();
	$loaderImg.show();
	$directoryList.hide();
	$directoryList.load('/soapbox/directory_search', input_string, function(responseText, textStatus){
	  $loaderImg.hide();
	  $directoryList.fadeIn(300);
	});
	// return true;	
}

$directoryInputs.change(updateDirectoryList);

function show_all_questions_linker() {
	tabs = $('#sidebar').tabs();
	$('#view-all-questions').attr('href', SOAPBOX_ENTRIES_URLS[tabs.tabs('option', 'selected')]);
	return true;
}

// Restaurant directory search
var $restoDirectoryList = $("#restaurant_directory_list");
// var $restoDirectoryInputs = $("#directory_search #restaurant_criteria #restaurant_search");
var $restoDirectoryInputs;
$restoDirectoryList.before($loaderImg);

$.fn.updateRestoDirectoryList = function() {
  $('html, body').animate({scrollTop: $('#restaurant_directory_list').offset().top -50}, 400);
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
$("#restaurant_by_name").click(function(){
  $restoDirectoryInputs = $("#directory_search #restaurant_criteria #restaurant_search");
  $.fn.updateRestoDirectoryList();
});
$("#restaurant_by_otm").click(function(){
  $restoDirectoryInputs = $("#directory_search #restaurant_criteria #otm_keyword_search");
  $.fn.updateRestoDirectoryList();
});
$("#restaurant_by_feature").click(function(){
  $restoDirectoryInputs = $("#directory_search #restaurant_criteria #feature_search");
  $.fn.updateRestoDirectoryList();
});
$("#restaurant_by_state").click(function(){
  $restoDirectoryInputs = $("#directory_search #restaurant_criteria #state_search");
  $.fn.updateRestoDirectoryList();
});
$("#restaurant_by_region").click(function(){
  $restoDirectoryInputs = $("#directory_search #restaurant_criteria #region_search");
  $.fn.updateRestoDirectoryList();
});
$("#restaurant_by_cuisine").click(function(){
  $restoDirectoryInputs = $("#directory_search #restaurant_criteria #cuisine_search");
  $.fn.updateRestoDirectoryList();
});

//

jQuery(document).ready(function(){
		jQuery('.standard-filler').formFiller();
    updateRestaurantSignupFields = function() {
    if ($('#role').val() == 'restaurant') {
      $('#restaurant_fields').show();
    } else {
      $('#restaurant_fields').hide();
    } 
  };
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