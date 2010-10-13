$(document).ready(function(){
	var panelHeight = homePanelHeight = 0;
	
	if($('#recent-activity').length > 0){
	
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
	}
	
	if($('#content.home .panel').length > 1){
		$('#content.home .panel').each(function(){
			if($(this).height() > homePanelHeight){
				homePanelHeight = $(this).height();
			}
		}).each(function(){
			$(this).height(homePanelHeight +'px');
		});
	}
	
	if($('#cycle').length > 0){
		$('#cycle').cycle({
			timeout: 8000,
			fx: 'uncover',
			easing: 'easeInOutCubic',
			pager: '#pager',
			pagerAnchorBuilder: buildPager,
			after: displayInfo
		});
	}
});
	
function buildPager(idx, elem){
	idx++;
	return '<a href="#">'+idx+'</a>';
}

function displayInfo(currSlideElement, nextSlideElement, options, forwardFlag){
	title = $(nextSlideElement).attr('data-title');
	caption = $(nextSlideElement).attr('data-caption');
	url = $(nextSlideElement).attr('data-url');
	link = '<a href=' + url + '>more&nbsp;&#187;</a>';
	$('#cycle-title').html(title);
	$('#cycle-caption').html(caption + link);
}