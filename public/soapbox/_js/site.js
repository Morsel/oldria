$(document).ready(function(){
	var panelHeight = homePanelHeight = tabablePanelHeight = 0;
	
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
		
		if($('#sidebar').height() > $('#inside').not('.home').height()){
			$('#inside').not('.home').height($('#sidebar').height() + 50 + 'px');
		}
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
	
	if($('#criteria_accordion').length > 0){
		$('#criteria_accordion').accordion({
			autoHeight: false,
			collapsible: true,
			active: false,
			header: '.accordion_box a',
			change: function() {
				$('.accordion_box').each(function(){
					if($(this).find('input:checked').length > 0){
						$(this).find('a').addClass('options_selected');
					} else {
						$(this).find('a').removeClass('options_selected');
					}
				});
			}
		}).find('.loading').removeClass('loading');
	}
	
	$('.showit').showy();
	$('.tabable').tabs({
		panelTemplate: '<ol></ol>',
		fx: { duration: 'fast', opacity: 'toggle' }
	}).find('.ui-tabs-panel').each(function(){	
		if($(this).height() > tabablePanelHeight){
			tabablePanelHeight = $(this).height();
		}
	}).each(function(){
		$(this).height(tabablePanelHeight +'px');
	});;
	
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