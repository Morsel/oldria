jQuery(document).ready(function(){
  jQuery('.searchBox > div').hover(function(){
    jQuery('.searchArrow').toggleClass('darkArrow');
    jQuery('.searchSubmit').toggleClass('darkBox');
  });
  jQuery('.box div:last').css({'border-right' : '0'});
  jQuery(function(jQuery){
    jQuery("#twitterBox").tweet({
      count: 3,
      query: "from:seaofclouds http",
      loading_text: "searching twitter..."
    });
  });
  jQuery(function(jQuery){
    jQuery(".tweet").tweet({
      username: "soapbox_HQ",
      join_text: "auto",
      count: 3,
      auto_join_text_default: "", 
      auto_join_text_ed: "",
      auto_join_text_ing: "",
      auto_join_text_reply: "",
      auto_join_text_url: "",
      loading_text: "loading tweets..."
    });
  });
  jQuery('.standard-filler').formFiller();
  jQuery('.terms').click(function (e) {
    jQuery('#basic-modal-content').modal();
    return false;
  });

  //Equal Height Columns
  var highestCol = Math.max(jQuery('.chefBox .content,').height(),jQuery('.pubBox .content').height(),jQuery('.mediaBox .content').height());
  jQuery('.content').height(highestCol);
  var highestCol = Math.max(jQuery('.footerBox').height());
  jQuery('.footerBox').height(highestCol);
  jQuery('.testimonial:odd div').css({'text-align': 'right'});

	updateRestaurantSignupFields = function() {
		if ($('#role').val() == 'restaurant') {
			$('#restaurant_fields').show();
		} else {
			$('#restaurant_fields').hide();
		} 
	};

});