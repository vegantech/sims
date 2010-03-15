# == Schema Information
# Schema version: 20090623023153
#
# Table name: flag_categories
#
#  id          :integer(4)      not null, primary key
#  district_id :integer(4)
#  category    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  threshold   :integer(4)      default(100)
#

class FlagCategory < ActiveRecord::Base
  #Could store icon, threshold for warning, description
  include LinkAndAttachmentAssets  #has many :assets
  belongs_to :district, :touch => true
  
  validates_uniqueness_of :category, :scope=>:district_id
  validates_inclusion_of :category, :in => Flag::FLAGTYPES.keys
  validates_numericality_of :threshold, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100


 

end
