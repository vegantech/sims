# == Schema Information
# Schema version: 20081111204313
#
# Table name: states
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class State < ActiveRecord::Base
  belongs_to :country
end
