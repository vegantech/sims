module LinkAndAttachmentAssets
  def self.included(klass)
    klass.send :after_update, :save_assets
    klass.send :has_many, :assets, :as => :attachable, :dependent => :destroy
  end
  
     
 
  def new_asset_attributes=(asset_attributes)
    asset_attributes.each do |attributes|
      assets.build(attributes)
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
    if !respond_to?(:deleted_at) || deleted_at.blank?
      assets.each do |asset|
        asset.save(false) unless asset.frozen?
      end
    end
  end 

end
