class InterventionDefinition < ActiveRecord::Base
  belongs_to :intervention_cluster
  belongs_to :frequency
  belongs_to :time_length
  belongs_to :tier
  belongs_to :user
  belongs_to :school
  has_many :recommended_monitors, :order => :position
  has_many :probe_definitions, :through => :recommended_monitors
  
  validates_presence_of :title, :description, :time_length_id, :time_length_num, :frequency_id, :frequency_multiplier
  validates_numericality_of :frequency_multiplier, :time_length_num

  acts_as_list :scope=>'intervention_cluster_id'

  def interventions
    []
  end

  def business_key
    "#{tier_id}-#{goal_definition.position}-#{objective_definition.position}    -#{intervention_cluster.position}-#{position}"
  end

  def goal_definition
    objective_definition.goal_definition
  end
  
  def objective_definition
    intervention_cluster.objective_definition
  end


  def disable!
    update_attribute(:disabled,true)
  end

  def ancestor_ids
    [objective_definition.goal_definition_id,objective_definition.id,intervention_cluster_id,id]
  end
end


