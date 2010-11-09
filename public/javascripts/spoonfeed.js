$('#jumbotron').cycle({
	fx: 'scrollHorz',
	timeout: 8000,
	easing: 'easeInOutCubic',
	pager: '#jumbotron_controller nav',
	pagerBuilder: jumbotronController
});

$('.hp_promo').equalHeights({
	panelTemplate: '<section></section>',
	fx: { duration: 'fast', opacity: 'toggle' }
});

$('#profile-tabs').tabs();

function jumbotronController(idx, elem){
	idx++;
	return html+='<a href="#">'+idx+'</a>';
}