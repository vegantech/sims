jQuery ->
  $(document).on "change","#quicklist select#intervention_definition_id", ->
    @.form.submit()
  $(document).on "change",".new_form select.sim_submit", ->
    $(@).next('.spinner').show()
    simulate @form, "submit"

