# == Schema Information
# Schema version: 20081111204313
#
# Table name: countries
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Country < ActiveRecord::Base
end
