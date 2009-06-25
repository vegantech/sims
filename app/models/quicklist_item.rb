# == Schema Information
# Schema version: 20090623023153
#
# Table name: quicklist_items
#
#  id                         :integer(4)      not null, primary key
#  school_id                  :integer(4)
#  district_id                :integer(4)
#  intervention_definition_id :integer(4)
#  created_at                 :datetime
#  updated_at                 :datetime
#

class QuicklistItem < ActiveRecord::Base
  belongs_to :district
  belongs_to :school
  belongs_to :intervention_definition
  delegate :title, :to=> :intervention_definition

end
