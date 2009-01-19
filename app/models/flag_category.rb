class FlagCategory < ActiveRecord::Base
  #Could store icon, threshold for warning, description
  belongs_to :district
  has_many :assets, :as => :attachable, :dependent => :destroy
  
  validates_uniqueness_of :category, :scope=>:district_id
  validates_inclusion_of :category, :in => Flag::FLAGTYPES.keys
  validates_numericality_of :threshold, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100


  #TODO extract these into a module
  after_update :save_assets

   
 
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
    assets.each do |asset|
      asset.save(false)
    end
  end 

  #END BLOCK TO EXTRACT TO MODULE
  

end
