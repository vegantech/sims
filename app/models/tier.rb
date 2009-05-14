# == Schema Information
# Schema version: 20090428193630
#
# Table name: tiers
#
#  id          :integer         not null, primary key
#  district_id :integer
#  title       :string(255)
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Tier < ActiveRecord::Base
  
  belongs_to :district
  acts_as_list :scope=>'district_id'
  validates_presence_of :title

  def to_s
    "#{position} - #{title}"
  end
end
