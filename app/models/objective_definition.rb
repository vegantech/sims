# == Schema Information
# Schema version: 20101101011500
#
# Table name: objective_definitions
#
#  id                 :integer(4)      not null, primary key
#  title              :string(255)
#  description        :text
#  goal_definition_id :integer(4)
#  position           :integer(4)
#  disabled           :boolean(1)
#  created_at         :datetime
#  updated_at         :datetime
#

class ObjectiveDefinition < ActiveRecord::Base
  include LinkAndAttachmentAssets
  belongs_to :goal_definition
  has_many :intervention_clusters, :order =>:position, :dependent=> :destroy

  validates_presence_of :title, :description
  validates_uniqueness_of :description, :scope => [:goal_definition_id,:title]
  acts_as_list :scope => :goal_definition_id
  acts_as_reportable if defined? Ruport

  define_statistic :count , :count => :all, :joins => :goal_definition
  define_statistic :distinct_titles , :count => :all,  :select => 'distinct objective_definitions.title', :joins=>:goal_definition
  define_calculated_statistic :districts_with_changes do
    find(:all,:group => "#{self.name.tableize}.title", :having => "count(#{self.name.tableize}.title)=1",:select =>'distinct district_id', :joins => :goal_definition).length
  end



  def disable!
    intervention_clusters.each(&:disable!)
    update_attribute(:disabled,true)
  end

  def to_s
    title
  end


end
