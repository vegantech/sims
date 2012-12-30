jQuery ->
  $('#unattached_interventions .end_date SELECT').change ->
    id = parseInt(@id.replace("end_date",""))
    date_fields = $(@).parent().children 'select'
    for i in [0..2]
      month = date_fields[i].value if date_fields[i].name.match(/month/)
      day = date_fields[i].value if date_fields[i].name.match(/day/)
      year = date_fields[i].value if date_fields[i].name.match(/year/)
    $.ajax(
      dataType: 'script',
      type: 'PUT',
      data: {year: year, month: month, day:day},
      url: '/unattached_interventions/'+id+'/update_end_date',
    )
  $('#unattached_interventions .participants_list_intervention select').change ->
    id=parseInt $(@).parent('div.participants_list_intervention').attr('id').replace("participants_list_intervention_","")
    alert id
    $.ajax(
      dataType: 'script',
      type: 'PUT',
      data: {user_id: @value},
      url: '/unattached_interventions/'+id
    )
