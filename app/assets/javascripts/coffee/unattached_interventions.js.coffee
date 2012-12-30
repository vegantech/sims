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
      complete: ->
        console.log 'done'
    )
  $('#unattached_interventions .participants_list_intervention select').change ->
    alert 'oops'


###
              {:onchange => remote_function(:url =>  update_end_date_unattached_intervention_path(intervention), 
                                            :with => "'month=' + $('end_date#{intervention.id}-mm').value + '&day=' + $('end_date#{intervention.id}-dd').value +'&year=' + $('end_date#{intervention.id}').v
                        :method => 'put')}
            %>

   :onchange => remote_function(:url =>  unattached_intervention_path(intervention), 
                        :with => "'user_id=' + $('#{dom_id(intervention,"new_participant")}').value",
                        :method => 'put')}
                       ) 
    ###
