$(document).ready(function(){
	var panelHeight = homePanelHeight = 0;
	
	$('#recent-activity').tabs({
		panelTemplate: '<ol></ol>',
		fx: { duration: 'fast', opacity: 'toggle' }
	}).find('ol').each(function(){	
		if($(this).height() > panelHeight){
			panelHeight = $(this).height();
		}
	}).each(function(){
		$(this).height(panelHeight +'px');
	});

	$('#inside').not('.home').height($('#main').height() - 50 + 'px');
	
	$('#content.home .panel').each(function(){
		if($(this).height() > homePanelHeight){
			homePanelHeight = $(this).height();
		}
	}).each(function(){
		$(this).height(homePanelHeight +'px');
	});
});