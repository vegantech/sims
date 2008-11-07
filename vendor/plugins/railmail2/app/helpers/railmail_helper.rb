module RailmailHelper
  def delivery_body(d)
    
    raw = d.raw
    return raw.body unless raw.multipart?
    
    part = raw.parts.select {|p| p.content_type == 'text/html'}.first.body
    part ||= "<pre class=\"plain_text\">#{raw.parts.select {|p| p.content_type == 'text/plain'}.first.body}</pre>"
    part ||= raw.parts[0].body
    part
  end
end
