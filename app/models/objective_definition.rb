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
  validates_uniqueness_of :description, :scope => [:goal_definition_id,:title, :deleted_at]
  acts_as_list :scope => :goal_definition_id
  is_paranoid

  def disable!
    intervention_clusters.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def to_s
    title
  end

  def deep_clone(gd)
    k=gd.objective_definitions.find_with_destroyed(:first,:conditions=>{:copied_from=>id, :goal_definition_id => gd.id})
    if k
      #already exists
    else
      k=clone
      k.copied_at=Time.now
      k.copied_from = id
      k.goal_definition=gd
      k.save! if k.valid?
    end
    k.intervention_clusters << intervention_clusters.collect{|o| o.deep_clone(k)}
    k
  end
end
