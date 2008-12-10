# == Schema Information
# Schema version: 20081208201532
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
  TIERS=Tier.find(:all,:order=>"position")

  def to_s
    title
  end
end
