$('#jumbotron').cycle({
	fx: 'scrollHorz',
	timeout: 8000,
	easing: 'easeInOutCubic',
	pager: '#jumbotron_controller nav',
	pagerBuilder: jumbotronController
});

function jumbotronController(idx, elem){
	idx++;
	return html+='<a href="#">'+idx+'</a>';
}