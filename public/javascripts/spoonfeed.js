$('#jumbotron').cycle({
	fx: 'scrollHorz',
	timeout: 8000,
	easing: 'easeInOutCubic',
	pager: '#jumbotron_controller nav',
	pagerBuilder: jumbotronController
});

$('.hp_promo, .chapter').equalHeights();
$('.culinary_job').equalHeights();
$('.nonculinary_job').equalHeights();
$('.award').equalHeights();
$('.accolade').equalHeights();
$('.enrollment').equalHeights();
$('.competition').equalHeights();
$('.internship').equalHeights();
$('.stage').equalHeights();
$('.apprenticeship').equalHeights();
$('#profile-account, #profile-summary').equalHeights();

$('#profile-tabs').tabs({
	panelTemplate: '<section></section>',
	fx: { duration: 'fast', opacity: 'toggle' }
});

$('.new_question').live('click', function(){
	$(this).css({
		backgroundRepeat: 'no-repeat',
		backgroundPosition: 'center center',
		backgroundImage: 'url(/images/redesign/ajax-loader.gif)'
	})
})
$('#profile_answer_submit').live('click', function(){
	$(this).val('posting...').attr('disabled','disabled');
})
$('#new_quick_reply button').live('click', function(){
	$(this).text('posting...').attr('disabled','disabled');
});

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

$(document).ready(function(){
	var bindColorbox = function() {
	  $('.colorbox').colorbox({
	      initialWidth: 450,
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


// == Dynamic Updates for Employment Searching
var	$employmentsList  = $("#employment_list");
var $employmentInputs = $("#employment_criteria input[type=checkbox]");
var $loaderImg =        $('<img class="loader" src="/images/ajax-loader.gif" />').hide();

// load the image load indicator, hidden
$employmentsList.before($loaderImg);

function updateEmploymentsList() {
	input_string = $employmentInputs.serialize();
	$loaderImg.show();
	$employmentsList.hide();
	$employmentsList.load('/employment_search', input_string, function(responseText, textStatus){
	  $loaderImg.hide();
	  $employmentsList.fadeIn(300);
	});
	// return true;	
}

$employmentInputs.change(updateEmploymentsList);

// Directory search
var	$directoryList  = $("#directory_list");
var $directoryInputs = $("#directory_search #employment_criteria input[type=checkbox]");

$directoryList.before($loaderImg);

function updateDirectoryList() {
	input_string = $directoryInputs.serialize();
	$loaderImg.show();
	$directoryList.hide();
	$directoryList.load('/directory/search', input_string, function(responseText, textStatus){
	  $loaderImg.hide();
	  $directoryList.fadeIn(300);
	});
	// return true;	
}

$directoryInputs.change(updateDirectoryList);

