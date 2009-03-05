// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
//

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


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


function change_date(){
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
      
      }
     
    }


var Checklist = {
  setup:function() {
    $$('a.questionLink').invoke('observe', 'click', Checklist.showQuestion)
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

