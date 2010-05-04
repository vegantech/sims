class ConsultationFormBuilder < ActionView::Helpers::FormBuilder

  def text_area(field,*args)
    
    '<p>'+object.send(field).to_s() +'</p>'
  end

  def label(field,text,*args)
    '<b>' + text.to_s + '</b>'
  end

end
