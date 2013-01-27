jQuery ->
  $(document).on "change","select#team_consultation_team_id", ->
    if $('#assets_school_team_' + @value).length
      if jQuery.grep($('#form_consultation_form textarea'), (o) -> o.value).length
        $('#form_consultation_form').show()
      else
        $('#form_consultation_form').hide()
    else
      $('#form_consultation_form').show()
