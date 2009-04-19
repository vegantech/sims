# == Schema Information
# Schema version: 20090325230037
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
#  deleted_at                 :datetime
#  copied_at                  :datetime
#  copied_from                :integer
#

class RecommendedMonitor < ActiveRecord::Base
  belongs_to :intervention_definition
  belongs_to :probe_definition

  delegate :title, :to=>:probe_definition
  acts_as_list :scope=>:intervention_definition_id
  is_paranoid

  def recommended_frequency_mult
    InterventionProbeAssignment::RECOMMENDED_FREQUENCY
  end

  def deep_clone(district)
    #assumes intervention definition and probe definitions have already been cloned
    
    k=RecommendedMonitor.find_with_destroyed(:first,:conditions=>{:copied_from=>id, :probe_definitions=>{:district_id=>district.id,:copied_from=>probe_definition_id} }, :joins =>:probe_definition) 
    if k
      #it already exists
   else
     
      k=clone
      k.probe_definition = ProbeDefinition.find(:first, :conditions => {:copied_from =>probe_definition_id, :district_id => district.id})
      k.intervention_definition = InterventionDefinition.find(:first,:joins=>{:intervention_cluster=>{:objective_definition=>:goal_definition}}, 
      :conditions =>{:copied_from => intervention_definition_id, :goal_definitions=>{:district_id=>district.id}})
      #["district_id =?", district.id])
      #      raise if k.intervention_definition.nil?
      k.copied_at=Time.now
      k.copied_from = id
      k.save! #if k.valid?
    end
    k
  end

  def build_intervention_probe_assignment
    probe_definition.intervention_probe_assignments.build if probe_definition
  end
end
