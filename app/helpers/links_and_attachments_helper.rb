module LinksAndAttachmentsHelper

  def add_asset_link(name, parent)
    link_to_function name do |page|
      page.insert_html :bottom, :assets, :partial => 'assets/asset', :object => Asset.new,
        :locals =>{:parent => parent}
    end
  end

  def links_and_attachments(obj, tag_type)
    obj.assets.collect do |asset| 
      d=''
      d+= content_tag(tag_type, link_to_with_icon(asset.name, asset.url)) unless asset.url.blank? 
      d+= content_tag(tag_type, link_to_with_icon(asset.document.original_filename, asset.document.url)) if asset.document? 
      d
    end.join(" ")

  end

end
