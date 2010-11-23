$('#jumbotron').cycle({
	fx: 'scrollHorz',
	timeout: 8000,
	easing: 'easeInOutCubic',
	pager: '#controller',
	pagerBuilder: jumbotronController
});

$('#bottom_promos section').equalHeights();

function jumbotronController(idx, elem){
	idx++;
	return html+='<a href="#">'+idx+'</a>';
}