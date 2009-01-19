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

  def link_to_add_attachment(object)
    link_to 'Add Attachment', {:controller=>"attachment",:action=>:new,
    :class=>object.class, :id=>object} ,{:method=>:post} if object.respond_to?"attachments"
  end

  def link_to_add_link(object)
    link_to 'Add Link', {:controller=>"link",:action=>:new,
    :class=>object.class, :id=>object} ,{:method=>:post} if object.respond_to?"links"
  end

  def list_links_and_attachments_with_delete(object)
    list_links_and_attachments(object,true)
  end

  def list_links_and_attachments(object,do_delete=false)
    list_attachments(object,do_delete).to_s +
    list_links(object,do_delete).to_s
  end

  def list_links_with_delete(object)
    list_links(object,true)
  end

  def list_links(object, do_delete=false)
      content_tag :ul, render(:partial=>"link/link",:collection=>object.links, :locals=>{:delete=>do_delete}) if object.respond_to?(
                                                                "links") and object.links.size>0
  end

  def list_attachments_with_delete(object)
    list_attachments(object,true)
  end

  def all_objective_definition_attachments(tier=1)
    ObjectiveDefinition.all_attachments(tier)
  end
    
  def list_attachments(object, do_delete=false)
    if object.respond_to?:size
      collection=object
    else
      collection=object.attachments if object.respond_to?( "attachments")
    end
    collection=Array(collection)
    
    content_tag :ul, render(:partial=>"attachment/attachment", :collection=>collection, :locals=>{:delete=>do_delete}) if collection.size >0
  end
end
