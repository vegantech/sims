$ ->
  $('a.google-oauth').click ->
    unless window.top == window.self
      @target = "_blank"
