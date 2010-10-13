$(document).ready(function(){
	var panelHeight = 0;
	
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

	$('#inside').height($('#sidebar').height() - 50 + 'px');
	
});