jQuery ->
  $('#grouped_progress_list .numerator, #grouped_progress_list .demoninator').change ->
    calculate_percentage($(@))
  $('#global_date select').change ->
    $('#grouped_progress_list td select:first-child').val($('#global_date select:first-child').val())
    $('#grouped_progress_list td select:nth-child(2)').val($('#global_date select:nth-child(2)').val())
    $('#grouped_progress_list td select:nth-child(3)').val($('#global_date select:nth-child(3)').val())
  $('form.edit_grouped_progress_entry a#new_participant_link').click (event) ->
    event.preventDefault()
    $("#participants_list").append($("div.hidden_participant").last().clone().show())
    $('#participants_list div').show()
    $('#participants_list select').removeAttr('disabled')

calculate_percentage = (field) ->
  score_field = field.parent().children('.score')
  numerator = field.parent().children('.numerator').val()
  denominator = field.parent().children('.demoninator').val()
  score = parseInt(100*numerator/denominator)
  if !isNaN(score)
    score_field.val score
