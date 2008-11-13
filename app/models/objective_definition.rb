# == Schema Information
# Schema version: 20081111204313
#
# Table name: objective_definitions
#
#  id                 :integer         not null, primary key
#  title              :string(255)
#  description        :text
#  goal_definition_id :integer
#  position           :integer
#  disabled           :boolean
#  created_at         :datetime
#  updated_at         :datetime
#

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
