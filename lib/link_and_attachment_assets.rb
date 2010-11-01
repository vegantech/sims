module LinkAndAttachmentAssets
  def self.included(klass)
    klass.send :after_update, :save_assets
    klass.send :has_many, :assets, :as => :attachable, :dependent => :destroy
  end
  
     
 
  def new_asset_attributes=(asset_attributes)
    asset_attributes.each do |attributes|
#      attributes={:document=>attributes} unless attributes.respond_to?(:values)    #needed for webrat attach_file?
      a=assets.build(attributes) unless attributes.values.all?(&:blank?)
    end
  end
  
  def existing_asset_attributes=(asset_attributes)
    assets.reject(&:new_record?).each do |asset|
      attributes = asset_attributes[asset.id.to_s]
      if attributes
        asset.attributes = attributes
      else
        assets.destroy(asset)
      end
    end
  end
  
  def save_assets
    assets.each do |asset|
      asset.save(false) unless asset.frozen? 
    end
  end 

end
