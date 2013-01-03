jQuery ->
  $('#checklist a.questionLink').click (e) ->
    question = $(@).parent('p').next('div.questionDiv')
    if !question.is(':visible')
      $('div.questionDiv:visible').hide "blind", {direction: "vertical"},500
      question.show "blind", {direction: "vertical"}, 500
    false
