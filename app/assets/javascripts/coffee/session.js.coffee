jQuery ->
  $('a#logout_link').click (e) ->
    $('body').data 'user',''
    $('body').data 'student',''
