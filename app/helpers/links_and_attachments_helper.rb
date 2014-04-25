module LinksAndAttachmentsHelper

  def add_asset_link(name, parent, suffix = "")
    a = content_tag :div, class: "hidden_asset", style: "display:none" do
      render partial: "/assets/asset", object: Asset.new, locals: {parent: parent}
    end
    a + link_to(name, "", class: "new_asset_link", data: {parent: parent, suffix: suffix})
  end

  def links_and_attachments(obj, tag_type)
    return "" unless obj.respond_to? "assets"
    obj.assets.inject("") do |str,asset|
      str += content_tag(tag_type, link_to_with_icon(asset.name, asset.url)) unless asset.url.blank? or asset.destroyed?
      if asset.document?
        if ["image/jpeg", "image/png", "image/gif"].include?(asset.document.content_type.strip)
          str += content_tag(tag_type, image_tag(asset.document.url, alt: asset.document.original_filename)) if asset.document?
        else
          str += content_tag(tag_type, link_to_with_icon(asset.document.original_filename, asset.document.url)) if asset.document?
        end
      end
      str += "#{asset.user} on #{asset.updated_at}" if obj.show_asset_info?
      str.html_safe
    end
  end
end
