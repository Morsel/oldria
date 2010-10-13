$(document).ready(function(){
	var panelHeight = 0;
	
	$('#recent-activity').tabs({
		panelTemplate: '<ol></ol>'
	}).find('ol').each(function(){	
		if($(this).height() > panelHeight){
			panelHeight = $(this).height();
		}
	}).each(function(){
		$(this).height(panelHeight +'px');
	});
});