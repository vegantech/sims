# == Schema Information
# Schema version: 20090212222347
#
# Table name: flag_categories
#
#  id          :integer         not null, primary key
#  district_id :integer
#  category    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  threshold   :integer         default(100)
#

class FlagCategory < ActiveRecord::Base
  #Could store icon, threshold for warning, description
  include LinkAndAttachmentAssets  #has many :assets
  belongs_to :district
  
  validates_uniqueness_of :category, :scope=>:district_id
  validates_inclusion_of :category, :in => Flag::FLAGTYPES.keys
  validates_numericality_of :threshold, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100


 

end
