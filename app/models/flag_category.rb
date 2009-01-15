class FlagCategory < ActiveRecord::Base
  #Could store icon, threshold for warning, description
  belongs_to :district
  validates_uniqueness_of :category, :scope=>:district_id
  validates_inclusion_of :category, :in => Flag::FLAGTYPES.keys
end
