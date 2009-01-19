class FlagCategory < ActiveRecord::Base
  #Could store icon, threshold for warning, description
  include LinkAndAttachmentAssets  #has many :assets
  belongs_to :district
  
  validates_uniqueness_of :category, :scope=>:district_id
  validates_inclusion_of :category, :in => Flag::FLAGTYPES.keys
  validates_numericality_of :threshold, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100


 

end
