$('#media_requests .media_request').click(function(){
	location.href = $(this).find('.reply_link > a').attr('href');
});