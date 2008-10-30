# == Schema Information
# Schema version: 20081030035908
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
  TIMELENGTHS=TimeLength.find(:all)
end
