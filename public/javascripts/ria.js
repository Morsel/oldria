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
	credit = 'Photo Credit: ' + $(nextSlideElement).attr('data-credit');
	caption = $(nextSlideElement).attr('data-caption');
	url = $(nextSlideElement).attr('data-url');
	title = url.length > 0 ? '<a href="' + url + '">' + $(nextSlideElement).attr('title') + '</a>' : $(nextSlideElement).attr('title');
	link = url.length > 0 ? ' <a href="' + url + '">learn&nbsp;more&nbsp;&#187;</a>' : '';
	$('#jumbo_promo h1').html(title);
	$('#jumbo_promo p').html(caption + link);
}