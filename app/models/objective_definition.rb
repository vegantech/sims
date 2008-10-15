class ObjectiveDefinition < ActiveRecord::Base
  belongs_to :goal_definition
  has_many :intervention_clusters, :order =>:position
  
  validates_presence_of :title, :description
  acts_as_list :scope=>:goal_definition_id

  def disable!
    intervention_clusters.each(&:disable!)
    update_attribute(:disabled,true)
  end
end
