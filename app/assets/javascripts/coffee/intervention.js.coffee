window.adjust_end_date = (pd=false) ->
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

      if pd == false
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
    e=jQuery.Event('submit')
    $(@).parents('form').trigger(e)
  $(document).on "click",".remove_participant", ->
    $(@).parent('div').remove()
  $(document).on "click", '.edit_intervention a#new_participant_link, .new_intervention a#new_participant_link', (event) ->
    event.preventDefault()
    $("#participants_list").append($("div.hidden_participant").last().clone().show())
    $('#participants_list div').show()
    $('#participants_list select').removeAttr('disabled')
    false
  $(document).on "change","select.change_date", ->
    adjust_end_date()
  $(document).on "change","select#intervention_intervention_probe_assignment_probe_definition_id", ->
    $('#spinnerassign_progress').show()
    $.ajax
      dataType: 'script',
      type: 'GET',
      url: '/interventions/ajax_probe_assignment',
      data:
        id: @value
        intervention_id: $(@).data().interventionId
        custom_intervention: $(@).data().custom
  $(document).on "click","a.intervention_comment_cancel", (event) ->
    event.preventDefault()
    $(@).parents('tr').next('tr.intervention_comment').show()
    $(@).parents('tr').remove()
  $(document).on "click","a#enter_view_scores_link", ->
    $('#spinnerscore_link').show()
  $(document).on "click","a.preview_graph", (event ) ->
    event.preventDefault()
    $.ajax
      dataType: 'text',
      type: 'POST',
      url: @href,
      success: (data) ->
        $("a.preview_graph").nextAll('div.probe_graph').html(data)
      data:
        $(@).parents('#intervention_probe_assignment').find('input,select').serialize()
  $('a#end_intervention_link').click ->
    $(window).scrollTo $('#end_intervention_reasons').show()
  $('#end_intervention_reasons input[type=radio]').click ->
    if $('#end_intervention_reasons input[type=radio]:checked').length < 2
      $('#end_submit_tag').prop('disabled', 'disabled')
    else
      $('#end_submit_tag').removeAttr('disabled')

