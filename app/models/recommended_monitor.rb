# == Schema Information
# Schema version: 20090212222347
#
# Table name: recommended_monitors
#
#  id                         :integer         not null, primary key
#  intervention_definition_id :integer
#  probe_definition_id        :integer
#  note                       :string(255)
#  position                   :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#

class RecommendedMonitor < ActiveRecord::Base
  belongs_to :intervention_definition
  belongs_to :probe_definition

  acts_as_list :scope=>:intervention_definition_id
end
