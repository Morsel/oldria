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