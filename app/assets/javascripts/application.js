// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
//




document.observe("dom:loaded", function() {
  new PeriodicalExecuter(checkSession, 30);
  document.observe('click', function(e,el) {
    if (el = e.findElement('.toggler')) {
      $(el.readAttribute("data-toggle-id")).toggle();
      e.stop();
    }
    if (el = e.findElement('.plus_minus')) {
	el.up('li').toggleClassName('minus');
        e.stop();
    }
    if (el = e.findElement('.spell_check_button')) {
	var f=el.form;
	var speller = new spellChecker();
	speller.textInputs=$$('#'+f.id + ' .spell_check');
	speller.openChecker();
	e.stop();
    }
  });

  document.observe('mouseover', function(e,el) {
   if (el = e.findElement('.help-question')) {
      return overlib(el.readAttribute("data-help"));
   }
  });

  document.observe('mouseout', function(e,el) {
   if (el = e.findElement('.help-question')) {
     nd();
   }
  });

});

function check_same_boxes(obj) {
  $$('.'+obj.className).each(function(s){
      s.checked=obj.checked;
      });

}

function searchByIntervention() {
  document.getElementById('search_criteria_search_type_active_intervention').checked = true;
}

function searchByFlag() {
   document.getElementById('search_criteria_search_type_flagged_intervention').checked = true;
}

function selectStudents(){
    selected_boxes = document.select_students_form.elements["id[]"];
    for (x = 0; x < selected_boxes.length; x++){
      selected_boxes[x].checked = true;
    }
    if(!(selected_boxes.length > 0)){
      selected_boxes.checked = true;
    }
}

function unselectStudents(){
    selected_boxes = document.select_students_form.elements["id[]"];
    for (x = 0; x < selected_boxes.length; x++){
      selected_boxes[x].checked = false;
    }
    if(!(selected_boxes.length > 0)){
      selected_boxes.checked = false;
    }
}




var Checklist = {
  setup:function() {
          if (!($$('a.questionLink')[0] == null)) {
    $$('a.questionLink').invoke('observe', 'click', Checklist.showQuestion)
          }
  },
  showQuestion:function(e) {
    Event.stop(e)

    var element = Element.extend(Event.element(e))

    var questionDiv = element.up('p').next('div.questionDiv')
    
    if (!questionDiv.visible()) {
      Checklist.hideAllVisibleQuestions()
      new Effect.BlindDown(questionDiv, {queue:'end', 
                                         duration:0.75,
                                         afterFinish:Checklist.scrollToQuestion})
    }
  },
  hideAllVisibleQuestions:function() {
    $A($$('div.questionDiv')).each(function(div) {
      if (div.visible()) {
        new Effect.BlindUp(div, {queue:'end', duration:0.75})
      }
    })
  },
  scrollToQuestion:function(e) {
    e.element.previous('p').scrollTo()
  }
}

Event.observe(window,'load',function(){
  Checklist.setup();
})


function new_probe_scores() {
  var scores=$$('div#new_probe_forms input[type="text"]');
  var i1=$$('div#new_probe_forms *[name=\"intervention[intervention_probe_assignment][new_probes][][administered_at(1i)]\"]');
  var i2=$$('div#new_probe_forms *[name=\"intervention[intervention_probe_assignment][new_probes][][administered_at(2i)]\"]');
  var i3=$$('div#new_probe_forms *[name=\"intervention[intervention_probe_assignment][new_probes][][administered_at(3i)]\"]');
  var goal=$('intervention_intervention_probe_assignment_goal').getValue();

  var first2=$('intervention[intervention_probe_assignment]_first_date-mm');
  var first3=$('intervention[intervention_probe_assignment]_first_date-dd');
  var first1=$('intervention[intervention_probe_assignment]_first_date');
  
  var last2=$('intervention[intervention_probe_assignment]_end_date-mm');
  var last3=$('intervention[intervention_probe_assignment]_end_date-dd');
  var last1=$('intervention[intervention_probe_assignment]_end_date');

  var s="";

  var arLen=scores.length;
  for ( var i=0, len=arLen; i<len; ++i ){
    dates= scores[i].up().previousSiblings()[1].childElements();

    i1=dates[3];
    i2=dates[1];
    i3=dates[2];
    


    s=s + 'probes[' +i+ '][score]=' + scores[i].getValue() + '&' ;
    s=s + 'probes['+ i+'][administered_at(1i)]=' + i1.getValue() + '&' ;
    s=s + 'probes['+ i+'][administered_at(2i)]=' + i2.getValue() + '&' ;
    s=s + 'probes['+ i+'][administered_at(3i)]=' + i3.getValue() + '&' ;

  }
    s=s + 'goal='+goal + '&' ;

    s= s + 'first_date(1i)='+first1.getValue() + '&';
    s= s + 'first_date(2i)='+first2.getValue() + '&';
    s= s + 'first_date(3i)='+first3.getValue() + '&';

    s= s + 'end_date(1i)='+last1.getValue() + '&';
    s= s + 'end_date(2i)='+last2.getValue() + '&';
    s= s + 'end_date(3i)='+last3.getValue() + '&';

  return s;


}



function show_or_hide_team_consultation_form(e,team_ids_with_assets) {
  //if the team has no attachments, and the form is blank
  if(!team_ids_with_assets.include(e.value) ||
  $$('form.new_team_consultation textarea').any(function(textarea) { return textarea.value != ""}))
  {
    $("form_consultation_form").show();
    }
  else{
    $("form_consultation_form").hide();
  }


}

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
	  page_user = document.body.readAttribute('data-user');
	  page_student = document.body.readAttribute('data-student');
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
	  $('session_notice').update(str);

  }
