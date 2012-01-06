class ConsultationFormBuilder < ActionView::Helpers::FormBuilder
  include LinksAndAttachmentsHelper
  include ApplicationHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::UrlHelper


  def text_area(field,*args)
    '<p>'+object.send(field).to_s() +'</p>'
  end

  def label(field,text,*args)
    '<b>' + text.to_s + '</b>'
  end

  def assets
    "<ul>" + links_and_attachments(object,'li') + "</ul>"
  end

end
