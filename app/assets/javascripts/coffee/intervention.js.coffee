window.adjust_end_date = ->
    timeMult = parseInt($('#intervention_time_length_number').val())
    timeScope = $('#intervention_time_length_id option:selected').text()
    switch timeScope
      when 'Day' then days=1
      when 'Week' then days=7
      when 'Month' then days=30
      when 'Quarter' then days=45
      when 'Semester' then days=90
      when 'Year' then days=180
      else days=0


    timeVal = timeMult * days
    startDate= new Date($('#intervention_start_date').val(), (-1 + parseInt $('#intervention_start_date-mm').val()), $('#intervention_start_date-dd').val())
    if timeVal > 0
      startDate.setDate(startDate.getDate() + timeVal)
      $('#intervention_end_date-dd').val(startDate.getDate())
      $('#intervention_end_date-mm').val(1+startDate.getMonth())
      $('#intervention_end_date').val(startDate.getFullYear())

      $('#intervention\\[intervention_probe_assignment\\]_first_date').val $('#intervention_start_date').val()
      $('#intervention\\[intervention_probe_assignment\\]_first_date-mm').val $('#intervention_start_date-mm').val()
      $('#intervention\\[intervention_probe_assignment\\]_first_date-dd').val $('#intervention_start_date-dd').val()

      $('#intervention\\[intervention_probe_assignment\\]_end_date').val $('#intervention_end_date').val()
      $('#intervention\\[intervention_probe_assignment\\]_end_date-mm').val $('#intervention_end_date-mm').val()
      $('#intervention\\[intervention_probe_assignment\\]_end_date-dd').val $('#intervention_end_date-dd').val()
      ###
      #set progress monitor start and end dates to match
      debugger
      ###

jQuery ->
  $(document).on "change","#quicklist select#intervention_definition_id", ->
    @.form.submit()
  $(document).on "change",".new_form select.sim_submit", ->
    $(@).next('.spinner').show()
    simulate @form, "submit"
  $(document).on "click",".remove_participant", ->
    $(@).parent('div').remove()
  $(document).on "click", '.edit_intervention a#new_participant_link, .new_intervention a#new_participant_link', ->
    event.preventDefault()
    $("#participants_list").append($("div.hidden_participant").last().clone().show())
    $('#participants_list div').show()
    $('#participants_list select').removeAttr('disabled')
    false
  $(document).on "change","select.change_date", ->
    adjust_end_date()
  $(document).on "change","select#intervention_intervention_probe_assignment_probe_definition_id", ->
    $('#spinnerassign_progress').show()
    $.ajax(
      dataType: 'script',
      type: 'GET',
      url: '/interventions/ajax_probe_assignment',
      data:{id: @value, intervention_id: $(@).data().interventionID, custom_intervention: $(@).data().customIntervention}
    )
  $(document).on "click","a.intervention_comment_cancel", ->
    event.preventDefault()
    $(@).parents('tr').next('tr.intervention_comment').show()
    $(@).parents('tr').remove()

    ###
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

