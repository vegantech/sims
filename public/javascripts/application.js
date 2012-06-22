// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
//




document.observe("dom:loaded", function() {
  document.observe('click', function(e,el) {
    if (el = e.findElement('.toggler')) {
      $(el.readAttribute("data-toggle-id")).toggle();
      e.stop();
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

function grouped_change_date(){
  for (x=1; x<4; x++){
    val=$$('form.edit_grouped_progress_entry > select:nth-child('+(x+1) +')')[0];
    $$('td.date >select:nth-child('+ x+ ')').each(function(n) {
        n.value = val.value;
        });
  }

}


function calculate_percentage(field){
  base_id = field.id.replace("_numerator","").replace("_denominator","")
  numerator = $(base_id+'_numerator').value
  denominator = $(base_id+'_denominator').value
  score_field = $(base_id+'_score')
  score =  parseInt(100*numerator/denominator);
  if(!isNaN(score)){
    score_field.value = score ;
  }

}


function change_date(new_record){
    
    var timeType = document.StudentInterventionForm.elements["intervention[time_length_id]"].selectedIndex;
    var timeNum = document.StudentInterventionForm.elements["intervention[time_length_number]"].value;

    var typeMultiplier = 0;

      
    if(timeType == 0){
      //Day
      typeMultiplier = 1;
    }else if(timeType == 1){
      //Week
      typeMultiplier = 7;
    }else if(timeType == 2){
      //Month
      typeMultiplier = 30;
    }else if(timeType == 3){
      //Quarter
      typeMultiplier = 45;
    }else if(timeType == 4){
      //Semester
      typeMultiplier = 90;
    }else if(timeType == 5){
      //SchoolYear
      typeMultiplier = 180;
    }
    
    
    if((typeMultiplier >= 1)&&(timeNum >= 1)){
        var dateMonth=document.StudentInterventionForm.elements["intervention[start_date(2i)]"].selectedIndex
        var dateDay=document.StudentInterventionForm.elements["intervention[start_date(3i)]"].value;
        var dateYear=document.StudentInterventionForm.elements["intervention[start_date(1i)]"].value;
      
      //Create the Date object for the starting date
        var startDate=new Date(dateYear, dateMonth , dateDay);
        var millisec = startDate.getTime();
      var newMillisec = millisec+1000*60*60*24*(typeMultiplier * timeNum);
      var endDate = new Date();
      endDate.setTime(newMillisec);
      var YearDiff = endDate.getFullYear()-dateYear;
      
      document.StudentInterventionForm.elements["intervention[end_date(3i)]"].value = endDate.getDate().toString();
      document.StudentInterventionForm.elements["intervention[end_date(1i)]"].value = endDate.getFullYear()
      document.StudentInterventionForm.elements["intervention[end_date(2i)]"].value = ((endDate.getMonth() + 1).toString());
      
      if((new_record == 'true') && (typeof(document.StudentInterventionForm.elements["intervention[intervention_probe_assignment][first_date(1i)]"])) !== 'undefined'){
       document.StudentInterventionForm.elements["intervention[intervention_probe_assignment][first_date(1i)]"].value = document.StudentInterventionForm.elements["intervention[start_date(1i)]"].value;
       document.StudentInterventionForm.elements["intervention[intervention_probe_assignment][first_date(2i)]"].value = document.StudentInterventionForm.elements["intervention[start_date(2i)]"].value;
       document.StudentInterventionForm.elements["intervention[intervention_probe_assignment][first_date(3i)]"].value = document.StudentInterventionForm.elements["intervention[start_date(3i)]"].value;


       document.StudentInterventionForm.elements["intervention[intervention_probe_assignment][end_date(1i)]"].value = document.StudentInterventionForm.elements["intervention[end_date(1i)]"].value;
       document.StudentInterventionForm.elements["intervention[intervention_probe_assignment][end_date(2i)]"].value = document.StudentInterventionForm.elements["intervention[end_date(2i)]"].value;
       document.StudentInterventionForm.elements["intervention[intervention_probe_assignment][end_date(3i)]"].value = document.StudentInterventionForm.elements["intervention[end_date(3i)]"].value;

      }
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

function toggle_visibility(id) {
       var e = document.getElementById(id);
       if(e.style.display == 'inline')
          e.style.display = 'none';
       else
          e.style.display = 'inline';
    }


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
