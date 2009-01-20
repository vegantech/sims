# == Schema Information
# Schema version: 20081227220234
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
  begin
    TIMELENGTHS = TimeLength.find(:all)
  rescue
    puts "Table may not exist yet."
    end
end
