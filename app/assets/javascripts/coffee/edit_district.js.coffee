jQuery ->
  $('#existing_logo a').click (event) ->
    event.preventDefault()
    $('#existing_logo').html('<input id="district_delete_logo" name="district[delete_logo]" type="hidden" value="1" />')
    $('#existing_logo').append('Your logo will be removed when you hit update.')
