# == Schema Information
# Schema version: 20081205205925
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
#  admin         :boolean
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
  has_many :news,:class_name=>"NewsItem"


  named_scope :normal, :conditions=>{:admin=>false}
  named_scope :admin, :conditions=>{:admin=>true}

  delegate :country, :to => :state
  
  validates_presence_of :abbrev,:name, :state
  validates_uniqueness_of :abbrev,:name, :scope=>:state_id
  validates_uniqueness_of :admin, :scope=>:state_id, :if=>lambda{|d| d.admin?}  #only 1 admin state per country
  validates_uniqueness_of :state_id,  :if=>lambda{|d| d.state && d.state.admin?}  #only 1 district per admin state
  
                                         
  before_destroy :make_sure_there_are_no_schools
  after_create :create_admin_user

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

  def administers
    if system_admin?
      System
    elsif country_admin?
      country
    elsif admin?
      state
    else
      self
    end
  end

  def system_admin?
    country_admin? && country.admin?
  end

  def country_admin?
    admin? && state.admin?
  end

  def to_s
    self.name
  end

private
  def make_sure_there_are_no_schools
    if schools.blank?
      schools.destroy_all
      users.destroy_all
      checklist_definitions.destroy_all
      recommendation_definitions.destroy_all
      goal_definitions.destroy_all
      probe_definitions.destroy_all
      tiers.destroy_all
      students.destroy_all
      special_user_groups.destroy_all
      news.destroy_all
    else 
      errors.add_to_base("Have the district admin remove the schools first.") 
      false
    end

  end

  def create_admin_user
    if self[:id].nil? && users.blank?
      u=Factory.build(:user,:username=>"district_admin", :first_name=>name, :last_name => "Administrator",:district_id=>self.id)
      u.roles=Role.find(:all,:conditions=>{:district_id=>nil, :name=>"district_admin"})
      u.save!
    end
  end
end

