module LinksAndAttachmentsHelper

  def add_asset_link(name, parent, suffix="")
    link_to_function name do |page|
      page.append_asset_link(parent,suffix)
    end
  end

  def append_asset_link(parent,suffix="")
    page.insert_html :bottom, "assets#{suffix}", :partial => 'assets/asset', :object => Asset.new,
        :locals =>{:parent => parent}
  end

  def links_and_attachments(obj, tag_type)
    return "" unless obj.respond_to? "assets"
    obj.assets.inject("") do |str,asset|
      str += content_tag(tag_type, link_to_with_icon(asset.name, asset.url)) unless asset.url.blank? 
      if asset.document?
        if ["image/jpeg", "image/png", "image/gif"].include?(asset.document.content_type.strip)
          str += content_tag(tag_type, image_tag(asset.document.url, :alt=>asset.document.original_filename)) if asset.document? 
        else
          str += content_tag(tag_type, link_to_with_icon(asset.document.original_filename, asset.document.url)) if asset.document? 
        end
      end
      str
    end

  end

end
