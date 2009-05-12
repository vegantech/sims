# == Schema Information
# Schema version: 20090428193630
#
# Table name: time_lengths
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  days       :integer
#  created_at :datetime
#  updated_at :datetime
#

class TimeLength < ActiveRecord::Base
  @all_cache_order ="days"
  include AllCache
end
