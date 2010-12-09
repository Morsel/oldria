$(document).ready(function(){
	
	$('.identity').equalHeights();
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
			$('#inside').not('.home').height($('#sidebar').height() + 50 + 'px');
		}
	}
	
	if($('#content.home .panel').length > 1){
		$('#content.home .panel').equalHeights();
	}
	
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
	

	
	
});
	
function buildPager(idx, elem){
	idx++;
	return '<a href="#">'+idx+'</a>';
}

function displayInfo(currSlideElement, nextSlideElement, options, forwardFlag){
	title = $(nextSlideElement).attr('data-title');
	caption = $(nextSlideElement).attr('data-caption');
	url = $(nextSlideElement).attr('data-url');
	credit = 'Photo Credit: ' + $(nextSlideElement).attr('data-credit');
	link = url.length > 0 ? '&nbsp;<a href=' + url + '>go&nbsp;&#187;</a>' : '';
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