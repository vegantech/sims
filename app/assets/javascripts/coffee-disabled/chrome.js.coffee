###
Chrome version 32 changed how scroll bars work.
This is causing problems with some select fields
with many options.    There's no way
to click on the scroll bar.   Suggest
an alternative of using keys or the scroll wheel
until it is fixed.
###
#

$ ->
  is_chrome = /chrome/.test navigator.userAgent.toLowerCase()

  if is_chrome
    updateSelect = ->
      $('select').filter ->
        return @children.length > 4
      .addClass("popup")
      .attr "data-help" ,
        "If you are having trouble scrolling the select box, you can use the middle mouse button \
        or the page up / page down keys.   This problem should be fixed with the next release of Google Chrome"
    updateSelect()
    $(document).ajaxComplete -> updateSelect()









