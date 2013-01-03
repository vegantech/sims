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
