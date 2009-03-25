# == Schema Information
# Schema version: 20090316004509
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

  delegate :title, :to=>:probe_definition
  acts_as_list :scope=>:intervention_definition_id
  acts_as_paranoid

  def recommended_frequency_mult
    InterventionProbeAssignment::RECOMMENDED_FREQUENCY
  end

  def build_intervention_probe_assignment
    probe_definition.intervention_probe_assignments.build if probe_definition
  end
end
