jQuery ->
  $('form#bulk_upload_form').uploadProgress({
    ### selector or element that will be updated  ###
    progressBar: "#progressbar",
    ### progress reports url ###
    progressUrl: "/progress",
    ### how often will bar be updated ###
    interval: 500
    jqueryPath: "<%=asset_path 'jquery.js'%>",
    uploadProgressPath: "<%=asset_path 'jquery.uploadProgress.js' %>"
    ###function called each time bar is updated  ###
    uploading: (upload) ->
      $('#percents').html(upload.percents + '%')
    start: ->
      $('#upload_progress').show()
      $('form#bulk_upload_form').prop "target", 'progressFrame'
    success: ->
      $('#form_import_results').show()
  })
