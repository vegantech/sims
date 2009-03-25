# == Schema Information
# Schema version: 20090325214721
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
  @@all_cache_order = "position"
  include AllCache
  belongs_to :district


  def to_s
    "#{position} - #{title}"
  end
  
end
