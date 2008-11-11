# == Schema Information
# Schema version: 20081111204313
#
# Table name: roles
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  district_id :integer
#  state_id    :integer
#  country_id  :integer
#  system      :boolean
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Role < ActiveRecord::Base
  belongs_to :district
  belongs_to :state
  belongs_to :country
  has_and_belongs_to_many :users

  acts_as_list # :scope =>[:district_id,:state_id, :country_id, :system]  need to fix this

  validate :belongs_to_exactly_one

  private

  def belongs_to_exactly_one
    num_parents = [district_id, state_id, country_id, system].inject(0){|sum,val| sum += (val ? 1 : 0) }
    errors.add_to_base("Invalid parents, should belong to exactly one") unless num_parents == 1
  end
end
