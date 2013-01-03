jQuery ->
  $(document).on "change","select#team_consultation_team_id", ->
  $('#intervention_definition_list').sortable(
    {handle:".handle"},
    update: (event, ui) ->
      id=$(@).sortable('toArray').toString().replace(/intervention_definition_/g,"")
      $.ajax(
        dataType: 'script',
        type: 'POST',
        data: {intervention_definition_list: id},
        url: $(@).data().url
      )
  )
  $('#probe_definition_list input[type=checkbox], #assign_probes_to_intervention input[type=checkbox]').click ->
    $('.' +@className ).prop('checked', @checked)
