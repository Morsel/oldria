jQuery(document).ready(function(){
  jQuery("#ourSites .tab:not(:first)").hide();

  //to fix u know who
  jQuery("#ourSites .tab:first").show();

  //when we click one of the tabs
  jQuery("#ourSites .htabs a").click(function(){
    //get the ID of the element we need to show
    stringref = jQuery(this).attr("href").split('#')[1];
    //hide the tabs that doesn't match the ID
    jQuery('#ourSites .tab:not(#'+stringref+')').hide();
    //fix
    if (jQuery.browser.msie && jQuery.browser.version.substr(0,3) == "6.0") {
      jQuery('#ourSites .tab#' + stringref).show();
    }
    else
    //display our tab fading it in
    jQuery('#ourSites .tab#' + stringref).show();
    //stay with me
    return false;
  });

  jQuery("#usage .tab:not(:first)").hide();

  //to fix u know who
  jQuery("#usage .tab:first").show();

  //when we click one of the tabs
  jQuery("#usage .htabs2 a").click(function(){
    //get the ID of the element we need to show
    stringref = jQuery(this).attr("href").split('#')[1];
    //hide the tabs that doesn't match the ID
    jQuery('#usage .tab:not(#'+stringref+')').hide();
    //fix
    if (jQuery.browser.msie && jQuery.browser.version.substr(0,3) == "6.0") {
      jQuery('#usage .tab#' + stringref).show();
    }
    else
    //display our tab fading it in
    jQuery('#usage .tab#' + stringref).show();
    //stay with me
    return false;
  });


  function selectNav() {
    jQuery(this)
    .parents('ul:first')
    .find('a')
    .removeClass('on')
    .end()
    .end()
    .addClass('on');
  }
  jQuery('.htabs, .htabs2').find('a').click(selectNav);
  jQuery('#mainTabs').hover(function(){
    jQuery('.message').fadeToggle('fast');	
  });
  jQuery('.testimonial:odd').css('text-align', 'right');

  jQuery('#mainTabs li a').hover(function(){
    jQuery(this).animate({"top":"-55px"}, 100);
  }, function(){
    jQuery(this).animate({"top":"-88px"}, 100);
  });

  jQuery('#mainTabs li').hover(function(){
    jQuery(this).animate({"height":"130px"}, 100);
  }, function(){
    jQuery(this).animate({"height":"100px"}, 100);
  });

  jQuery('#mainTabs li.chefs a').hover(function(){
    jQuery('h2.chefsMessage').toggle();
  });
  jQuery('#mainTabs li.publicists a').hover(function(){
    jQuery('h2.pubMessage').toggle();
  });
  jQuery('#mainTabs li.journalists a').hover(function(){
    jQuery('h2.journalistMessage').toggle();
  });
  jQuery('#mainTabs li.diners a').hover(function(){
    jQuery('h2.dinersMessage').toggle();
  });
  jQuery(function($){
    $("#twitterBox").tweet({
      count: 3,
      query: "from:seaofclouds http",
      loading_text: "searching twitter..."
    });
  });
  jQuery(function($){
    $(".tweet").tweet({
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

  // jQuery('.terms').click(function (e) {
  //   $('#basic-modal-content').modal();
  // 
  //   return false;
  // });

  updateRestaurantSignupFields = function() {
	if ($('#role').val() == 'restaurant') {
	  $('#restaurant_fields').show();
	} else {
	  $('#restaurant_fields').hide();
	} 
  };

});
