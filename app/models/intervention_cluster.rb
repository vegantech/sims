class InterventionCluster < ActiveRecord::Base
  belongs_to :objective_definition
  has_many :intervention_definitions, :order=>:position

  validates_presence_of :title
  acts_as_list :scope=>:objective_definition

  def disable!
    intervention_definitions.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def summary_with_parent_tables
    "#{self.objective_definition.goal_definition.title}/#{self.objective_definition.title}/#{self.title}"

  end
end
