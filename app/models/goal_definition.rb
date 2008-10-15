class GoalDefinition < ActiveRecord::Base
  belongs_to :district
  has_many :objective_definitions, :order =>:position

  validates_presence_of :title, :description
  acts_as_list :scope=>:district_id

  def disable!
    objective_definitions.each(&:disable!)
    update_attribute(:disabled,true)
  end

end
