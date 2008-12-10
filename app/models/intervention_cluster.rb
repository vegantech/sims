# == Schema Information
# Schema version: 20081208201532
#
# Table name: intervention_clusters
#
#  id                      :integer         not null, primary key
#  title                   :string(255)
#  description             :text
#  objective_definition_id :integer
#  position                :integer
#  disabled                :boolean
#  created_at              :datetime
#  updated_at              :datetime
#

class InterventionCluster < ActiveRecord::Base
  belongs_to :objective_definition
  has_many :intervention_definitions, :order=>:position

  delegate :goal_definition, :to => :objective_definition

  validates_presence_of :title
  acts_as_list :scope=>:objective_definition

  def disable!
    intervention_definitions.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def summary_with_parent_tables
    "#{self.goal_definition.title}/#{self.objective_definition.title}/#{self.title}"

  end
end
