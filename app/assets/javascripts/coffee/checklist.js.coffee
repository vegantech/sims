jQuery ->
  $('#checklist a.questionLink').click (e) ->
    question = $(@).parent('p').next('div.questionDiv')
    if !question.is(':visible')
      $('div.questionDiv:visible').hide "blind", {direction: "vertical"},500
      question.show "blind", {direction: "vertical"}, 500
    false
  $('#checklist input.autoset').click ->
    cls = @className.split(" ")[1]
    $(this).parents('table').find('input.' + cls).prop('checked','checked')
  $('input.show_elig').click ->
    $('#elig_criteria').show()
