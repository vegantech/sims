# == Schema Information
# Schema version: 20101101011500
#
# Table name: time_lengths
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  days       :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class TimeLength < ActiveRecord::Base
  @all_cache_order ="days"
  include AllCache
end
