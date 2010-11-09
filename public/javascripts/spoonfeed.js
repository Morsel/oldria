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


var colorboxOnComplete = function(){
  $('#culinary_job_chef_is_me').click(function(){
    var nameField = $('#culinary_job_chef_name');
    var $this     = $(this);
    if ($this.is(":checked")) {
      nameField.val($(this).attr('rel'));
    } else {
      nameField.val('');
    }
  });
};

$(document).ready(function(){
	var bindColorbox = function() {
	  $('.colorbox').colorbox({
	      initialWidth: 420,
	      maxWidth: 450,
	      maxHeight: 580,
	      onComplete: colorboxOnComplete,
	      onClosed: function() {
	        bindAjaxDeleters();
	        bindColorbox();
	      }
	  });
	};

  function close_box(){
    $.fn.colorbox.close();
  }

  $('.close').live('click', close_box);

  $('#new_quick_reply button').live('click', function(){
  	$(this).text('posting...');
  });

  function post_reply_text(){
    $('#new_quick_reply button').text('Post Reply');
  }

  // Do it!
  bindColorbox();

	$('#colorbox form.stage, #colorbox form.apprenticeship, #colorbox form.nonculinary_enrollment, #colorbox form.award, #colorbox form.culinary_job, #colorbox form.nonculinary_job, #colorbox form.accolade, #colorbox form.enrollment, #colorbox form.competition, #colorbox form.internship').live('submit', colorboxForm);
});

var colorboxForm = function(){
  var $form = $(this);
  // var button = $form.find('button:first');
  // button.disable();
  $form.ajaxSubmit({
    dataType: 'json',
    url: $form.attr('action') + '.json',
    success: function(text){
      var $html = $(text.html);
      var $id   = $html.attr('id');
      var singularName = $id.replace(/^new_/, "").replace(/_\d+$/, "");
      var existingElement = $('#'+ $id);
      if (existingElement.length) {
        existingElement.html($html.html());
      } else {
        $("#" + singularName + "s").append($html);
      }
      $.fn.colorbox.close();
    },
    error: function(xhr, status){
      var response;
      try { response = $(xhr.responseText); } catch(e) { response = xhr.responseText; }
      $.colorbox({html: response});
    }
  });
  // button.enable();

  return false;
};

