jQuery ->
  $('.checklist_definition a').bind 'ajax:before', ->
    $(@).siblings('img.spinner').show()
  $('.checklist_definition a').bind 'ajax:complete', ->
    $(@).siblings('img.spinner').hide()
  $(document).on "click","a.hide_notice", ->
    $(@).parent('div').slideToggle()

