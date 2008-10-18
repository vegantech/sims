class District < ActiveRecord::Base
  belongs_to :state
  has_many :users
  has_many :checklist_definitions
  has_many :goal_definitions, :order=>:position
  has_many :probe_definitions
  has_many :recommended_monitors, :through => :probe_definitions
  has_many :objective_definitions, :through => :goal_definitions

  GRADES=  %w{ PK KG 01 02 03 04 05 06 07 08 09 10 11 12}

  def grades
    GRADES
  end

  def find_intervention_definition_by_id(id)
    InterventionDefinition.find(id,:include=>{:intervention_cluster=>{:objective_definition=>:goal_definition}}, :conditions=>{'goal_definitions.district_id'=>self.id})
  end

end
