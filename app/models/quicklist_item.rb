# == Schema Information
# Schema version: 20090428193630
#
# Table name: quicklist_items
#
#  id                         :integer         not null, primary key
#  school_id                  :integer
#  district_id                :integer
#  intervention_definition_id :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#

class QuicklistItem < ActiveRecord::Base
  belongs_to :district
  belongs_to :school
  belongs_to :intervention_definition
  delegate :title, :to=> :intervention_definition

end
