//=require popup
//=require jquery
//=require jquery_ujs
//=require jquery.ui.effect-pulsate
//=require jquery.ui.effect-highlight
//=require jquery.ui.effect-blind
//=require jquery.ui.sortable
//=require jquery.nested-fields
//=require jquery.uploadProgress
//=require overlib
//=require spellerpages/spellChecker
//=require datepicker
//=require jquery.scrollTo
//=require_tree ./coffee
//=require_self

//
// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
//

$.fx.speeds._default= 750;

$(function() {
  $(document).on("click",".toggler",function(event) {
    event.preventDefault();
    $("#" + $(this).data().toggleId).toggle();
  });
  $('a.plus_minus').click(function() {
    return $(this).parent('li').toggleClass('minus');
  });
  $(document).on("mouseover",".popup,.help-question",function(event) {
    return overlib($(this).data().help);
  });
  $(document).on("mouseout",".popup,.help-question",function(event) {
    return nd();
  });
  $('.dbl_toggler').dblclick(function() {
    return $("#" + $(this).data().toggleId).toggle();
  });
  $('#student_search_form #search_criteria_grade').change(function() {searchCriteriaAjax("grade",$(this));});
  $('#student_search_form #search_criteria_user_id').change(function() {searchCriteriaAjax("member",$(this));}); 
  $('#student_search_form .flag_checkbox').click(function(){
    document.getElementById('search_criteria_search_type_flagged_intervention').checked = true;
  });
  $('#student_search_form .active_intervention_checkbox').click(function(){
    document.getElementById('search_criteria_search_type_active_intervention').checked = true;
  });
  $('#check_all').click(function() {
    var checked;
    checked = $('#check_all')[0].checked;
    return $('form input:checkbox').each(function() {
      this.checked = checked;
      return true;
    });
  });
  $(document).on("click",".spell_check_button",function(event){
	event.preventDefault();
	var f=this.form;
	var speller = new spellChecker();
	speller.textInputs=$('#'+f.id + ' .spell_check');
	speller.openChecker();
  });
  $(document).on("click",".cancel_link",function(event) {
    event.preventDefault();
    if(!$(this).data().jconfirm || confirm($(this).data().jconfirm)) {
	    $("#" + $(this).data().show).show();
	    $("#" + $(this).data().show2).show();
	    $("#" + $(this).data().remove).remove();
	    $(this).parents($(this).data().removeUp).first().remove();
    }
    return(false);
  });
  $(document).on("click",".new_asset_link",function(event) {
    event.preventDefault();
    $(this).before($(this).prev(".hidden_asset").first().clone().show());
  });
  $(document).on("click",".presubmit",function(event) {
    $(this).closest("form").find("input[name=" + $(this).data().toChange+ "]").val($(this).data().newValue);
  });
  $(document).on("click","#new_user_school_assignment_link",function(event) {
    event.preventDefault();
    $("#user_school_assignments").append($("#hidden_user_school_assignment tr, #hidden_user_school_assignment div").first().clone().removeAttr('disabled'));
    $("#user_school_assignments select,#user_school_assignments input").removeAttr("disabled");
  });
  $('form#new_student #student_id_state').blur(function() {
	  $('#spinnerid_state').show();
	  $.ajax({
		  dataType: 'script',
		  type: 'GET',
		  data: 'id_state=' + $(this).val(),
		  url: '/district/students/check_id_state',
		  complete: function( ) {
			  $('#spinnerid_state').hide();
		  }
	  });
  });

  $('form .awesome_nested').nestedFields();
  setInterval(checkSession,3000);
});

/**
 * Get value from the document cookie
 *
 * @param string name Name of the variable to retrieve
 * @return mixed
 */
function cookieGet(name)
{
	name = name + "=";
	var cookies = document.cookie.split(';');

	for (var i = 0; i < cookies.length; i++) {
		var c = cookies[i];
		while (c.charAt(0) == ' ') {
			c = c.substring(1, c.length);
		}
		if (c.indexOf(name) === 0) {
			return c.substring(name.length, c.length);
		}
	}

	return null;
}

function checkSession() {
	  cookie_student = cookieGet('selected_student');
	  cookie_user = cookieGet('user_id');
	  page_user = $('body').data('user');
	  page_student = $('body').data('student');
	  str = "";
	  if(page_user  && cookie_user != page_user){
		  str +="You've been logged out or another user is using SIMS in another window or tab.  ";
	  }
	  if(page_student && cookie_student != page_student){
		  str +="Currently, you cannot select two different students in different windows or tabs";
	  }

	  if(str != ""){
		str = "<br />Using multiple windows or tabs can cause errors or misplaced data in SIMS.  If you are seeing this message, you should close this window.<br /> " + str;
	  window.scrollTo(1,1);
	  }
	  $('#session_notice').html(str);

  }

function searchCriteriaAjax(crit,field) {
	var school_id = $('#student_search_form').data().school;
	var spinnerfield = field.next('img.spinner');
	$.ajax({
		url: "/schools/" + school_id + "/student_search/"+ crit,
		beforeSend: function(){ spinnerfield.show();},
		success: function(){ spinnerfield.hide();},
		data: {
			grade: escape($('#search_criteria_grade').val()),
		user: escape($('#search_criteria_user_id').val())
		},
		dataType: "script"
	}
	);
};

//from http://thetimbanks.com/2011/03/22/jquery-extension-toggletext-method/
jQuery.fn.toggleText = function (value1, value2) {
	    return this.each(function () {
		            var $this = $(this),
		               text = $this.text();

	            if (text.indexOf(value1) > -1)
		                $this.text(text.replace(value1, value2));
	            else
		                $this.text(text.replace(value2, value1));
	        });
};

