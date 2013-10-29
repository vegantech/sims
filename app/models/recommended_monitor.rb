# == Schema Information
# Schema version: 20101101011500
#
# Table name: recommended_monitors
#
#  id                         :integer(4)      not null, primary key
#  intervention_definition_id :integer(4)
#  probe_definition_id        :integer(4)
#  note                       :string(255)
#  position                   :integer(4)
#  created_at                 :datetime
#  updated_at                 :datetime
#

class RecommendedMonitor < ActiveRecord::Base
  DISTRICT_PARENT = :probe_definition
  belongs_to :intervention_definition
  belongs_to :probe_definition

  delegate :title, :to=>:probe_definition
  acts_as_list :scope=>:intervention_definition_id
  scope :active, joins(:probe_definition).merge(ProbeDefinition.active)
  scope :content_export, order

  def recommended_frequency_mult
    InterventionProbeAssignment::RECOMMENDED_FREQUENCY
  end

  def build_intervention_probe_assignment
    probe_definition.intervention_probe_assignments.build if probe_definition
  end
end
