$('#jumbotron-cycle').cycle({
	fx: 'scrollHorz',
	timeout: 8000,
	easing: 'easeInOutCubic',
	pager: '#jumbotron_controller nav',
	pagerBuilder: jumbotronController,
	after: displayInfo
})
$('.hp_promo').equalHeights();

function jumbotronController(idx, elem){
	idx++;
	return html+='<a href="#">'+idx+'</a>';
}

function displayInfo(currSlideElement, nextSlideElement, options, forwardFlag){
	the_title = $(nextSlideElement).attr('title');
	caption = $(nextSlideElement).attr('data-caption');
	url = $(nextSlideElement).attr('data-url');
	credit = 'Photo Credit: ' + $(nextSlideElement).attr('data-photo-credit');
	link = url.length > 0 ? '&nbsp;<a href=' + url + '>Learn&nbsp;more&nbsp;&#187;</a>' : '';
	title = url.length > 0 ? '<a href=' + url + '>'+ the_title +'</a>' : the_title;
	$('#jumbo_promo h1').html(title);
	$('#photo_credit').html(credit);
	$('#excerpt').html(caption + link);
}

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

// == Dynamic Updates for Employment Searching
var	$employmentsList  = $("#employment_list");
var $employmentInputs = $("#employment_criteria input[type=checkbox]");
var $loaderImg =        $('<img class="loader" src="/images/ajax-loader.gif" />').hide();

// load the image load indicator, hidden
$employmentsList.before($loaderImg);

function updateEmploymentsList() {
	input_string = $employmentInputs.serialize();
	$loaderImg.show();
	$employmentsList.hide();
	$employmentsList.load('/employment_search', input_string, function(responseText, textStatus){
	  $loaderImg.hide();
	  $employmentsList.fadeIn(300);
	});
	// return true;	
}

$employmentInputs.change(updateEmploymentsList);

// Directory search
var $loaderImg       = $('<img class="loader" src="/images/ajax-loader.gif" />').hide();
var	$directoryList   = $("#directory_list");
var $directoryInputs = $("#directory_search #employment_criteria input[type=checkbox]");

$directoryList.before($loaderImg);

function updateDirectoryList() {
	input_string = $directoryInputs.serialize();
	$loaderImg.show();
	$directoryList.hide();
	$directoryList.load('/mediafeed/directory_search', input_string, function(responseText, textStatus){
	  $loaderImg.hide();
	  $directoryList.fadeIn(300);
	});
	// return true;	
}

$directoryInputs.change(updateDirectoryList);
