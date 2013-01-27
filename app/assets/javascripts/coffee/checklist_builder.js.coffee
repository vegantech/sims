jQuery ->
  $(document).on 'ajax:before', '.checklist_definition a', ->
    $(@).siblings('img.spinner').show()
  $(document).on 'ajax:complete', '.checklist_definition a', ->
    $(@).siblings('img.spinner').hide()
  $(document).on "click","a.hide_notice", ->
    $(@).parent('div').slideToggle()

