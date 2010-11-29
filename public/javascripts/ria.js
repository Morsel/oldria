$('#jumbotron').cycle({
	fx: 'scrollHorz',
	timeout: 8000,
	easing: 'easeInOutCubic',
	pager: '#controller',
	pagerBuilder: jumbotronController,
	after: displayInfo
});

$('#bottom_promos section').equalHeights();

function jumbotronController(idx, elem){
	idx++;
	return html+='<a href="#">'+idx+'</a>';
}

function displayInfo(currSlideElement, nextSlideElement, options, forwardFlag){
	title = $(nextSlideElement).attr('title');
	caption = $(nextSlideElement).attr('data-caption');
	url = $(nextSlideElement).attr('data-url');
	credit = 'Photo Credit: ' + $(nextSlideElement).attr('data-credit');
	link = '<a href=' + url + '>learn&nbsp;more&nbsp;&#187;</a>';
	$('#jumbo_promo h1').html(title);
	$('#jumbo_promo p').html(caption + "&hellip;&nbsp;" + link);
}