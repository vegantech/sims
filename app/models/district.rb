# == Schema Information
# Schema version: 20081111204313
#
# Table name: districts
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  abbrev        :string(255)
#  state_dpi_num :integer
#  state_id      :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class District < ActiveRecord::Base
  belongs_to :state
  has_many :users
  has_many :checklist_definitions
  has_many :recommendation_definitions
  has_many :goal_definitions, :order=>'position'
  has_many :probe_definitions
  has_many :recommended_monitors, :through => :probe_definitions
  has_many :objective_definitions, :through => :goal_definitions
  has_many :tiers
  has_many :schools
  has_many :students
  has_many :special_user_groups

  validates_presence_of :abbrev,:name

  GRADES=  %w{ PK KG 01 02 03 04 05 06 07 08 09 10 11 12}

  def grades
    GRADES
  end

  def find_intervention_definition_by_id(id)
    InterventionDefinition.find(id,:include=>{:intervention_cluster=>{:objective_definition=>:goal_definition}}, :conditions=>{'goal_definitions.district_id'=>self.id})
  end

  def search_intervention_by
    #FIXME some districts may not use goals or objectives
    #so they should be able to choose which to search by on the 
    #student search screen
    objective_definitions
  end

end
