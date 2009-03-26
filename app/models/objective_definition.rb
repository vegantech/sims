# == Schema Information
# Schema version: 20090325230037
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
#  deleted_at         :datetime
#  copied_at          :datetime
#  copied_from        :integer
#

class ObjectiveDefinition < ActiveRecord::Base
  include LinkAndAttachmentAssets
  belongs_to :goal_definition
  has_many :intervention_clusters, :order =>:position, :dependent=> :destroy
  
  validates_presence_of :title, :description
  validates_uniqueness_of :description, :scope => [:goal_definition_id,:title]
  acts_as_list :scope => :goal_definition_id
  acts_as_paranoid

  def disable!
    intervention_clusters.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def to_s
    title
  end

  def deep_clone
    o=self.clone
  end
end
