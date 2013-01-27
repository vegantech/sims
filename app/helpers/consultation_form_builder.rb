class ConsultationFormBuilder < ActionView::Helpers::FormBuilder
  def text_area(field,*args)
    @template.content_tag(:p, @template.send(:h,object.send(field).to_s()))
  end

  def label(field,text,*args)
    @template.content_tag(:b, @template.send(:h,text.to_s))
  end

  def assets
    @template.content_tag(:ul,  @template.links_and_attachments(object,'li') )
  end

end
