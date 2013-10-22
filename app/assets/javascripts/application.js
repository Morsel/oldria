//= require prototype
//= require prototype_ujs
//= require effects
//= require dragdrop
//= require controls
//= require jquery_ujs
// $('#media_requests .media_request').click(function(){
// 	location.href = $(this).find('.reply_link > a').attr('href');
// });

function remove_fields(link) {
  $(link).previous("input[type=hidden]").value = "1";
  $(link).up(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).up().insert({
    before: content.replace(regexp, new_id)
  });
}