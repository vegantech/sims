// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
//

$(function() {
  $('.toggler').click(function() {
    return $("#" + $(this).data().toggleId).toggle();
  });
  $('a.plus_minus').click(function() {
    return $(this).parent('li').toggleClass('minus');
  });
  $('.help-question').mouseover(function() {
    return overlib($(this).data().help);
  });
  $('.help-question').mouseout(function() {
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

