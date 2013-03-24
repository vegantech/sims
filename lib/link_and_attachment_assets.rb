module LinkAndAttachmentAssets
  def self.included(klass)
    klass.send :after_update, :save_assets
    klass.send :after_rollback, :preserve_uploads, unless: "errors.empty?"
    klass.send :has_many, :assets, :as => :attachable, :dependent => :destroy
  end



  def new_asset_attributes=(asset_attributes)
    asset_attributes.each do |attributes|
#      attributes={:document=>attributes} unless attributes.respond_to?(:values)    #needed for webrat attach_file?
      a=assets.build(attributes) unless attributes.except(:user_id,"user_id").values.all?(&:blank?)
    end
  end

  def existing_asset_attributes=(asset_attributes)
    @touch_me=false
    claim_assets(asset_attributes.keys) if new_record?
    assets.reject(&:new_record?).each do |asset|
      attributes = asset_attributes[asset.id.to_s]
      if attributes
        asset.attributes = attributes
      else
        @touch_me = true if asset.persisted?
        assets.destroy(asset)
      end
    end
  end

  def save_assets
    assets.each do |asset|
      @touch_me = true if asset.frozen? or asset.changed?
      asset.save(:validate => false) if !asset.frozen? and asset.changed?
    end
    if attributes["updated_at"] && @touch_me
      self.class.update_all(["updated_at = ?", Time.now], "id = #{self.id}")
    end
  end

  def preserve_uploads
    if assets.any?(&:preserve_file_after_parent_validation_failure!)
      self.class.update_all(["updated_at = ?", Time.now], "id = #{self.id}") if attributes["updated_at"] && persisted?
      errors[:base] = "The attachments have been saved, but the other changes have not."
    end
  end

  def claim_assets keys
    self.assets |= Asset.where(attachable_id: nil, id: keys)
  end

end
