class InterventionCluster < ActiveRecord::Base
  belongs_to :objective_definition

  validates_presence_of :title
  acts_as_list :scope=>:objective_definition

  def disable!
    intervention_definitions.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def intervention_definitions
    []
  end

end
