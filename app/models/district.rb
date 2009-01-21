# == Schema Information
# Schema version: 20090118224504
#
# Table name: districts
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  abbrev            :string(255)
#  state_dpi_num     :integer
#  state_id          :integer
#  created_at        :datetime
#  updated_at        :datetime
#  admin             :boolean
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

class District < ActiveRecord::Base
  ActiveSupport::Dependencies.load_missing_constant self, :StudentsController

  belongs_to :state
  has_many :users, :order => :username
  has_many :checklist_definitions
  has_many :flag_categories
  has_many :core_practice_assets, :through => :flag_categories, :source=>"assets"
  has_many :recommendation_definitions
  has_many :goal_definitions, :order=>'position'
  has_many :probe_definitions
  has_many :quicklist_items, :dependent=>:destroy
  has_many :quicklist_interventions, :class_name=>"InterventionDefinition", :through => :quicklist_items, :source=>"intervention_definition"
  has_many :recommended_monitors, :through => :probe_definitions
  has_many :objective_definitions, :through => :goal_definitions
  has_many :tiers
  has_many :schools, :order => :name
  has_many :students
  has_many :special_user_groups
  has_many :news,:class_name=>"NewsItem"
  has_many :roles


  has_attached_file  :logo


  named_scope :normal, :conditions=>{:admin=>false}
  named_scope :admin, :conditions=>{:admin=>true}

  delegate :country, :to => :state


  
  validates_presence_of :abbrev,:name, :state
  validates_uniqueness_of :abbrev,:name, :scope=>:state_id
  validates_uniqueness_of :admin, :scope=>:state_id, :if=>lambda{|d| d.admin?}  #only 1 admin state per country
  validates_uniqueness_of :state_id,  :if=>lambda{|d| d.state && d.state.admin?}  #only 1 district per admin state
  validates_format_of :abbrev, :with => /\A[0-9a-z]+\Z/i, :message => "Can only contain letters or numbers"
  
                                         
  before_destroy :make_sure_there_are_no_schools
  before_validation :clear_logo
  after_create :create_admin_user

  GRADES=  %w{ PK KG 01 02 03 04 05 06 07 08 09 10 11 12}

  def grades
    GRADES
  end

  def active_checklist_document
    checklist_definitions.active_checklist_definition.document
  end

  def active_checklist_document?
    checklist_definitions.active_checklist_definition.document?

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

  def reset_admin_password!
    u=users.find_by_username("district_admin")
    if u
      u.reset_password!
    else
      "Could not find user, try recreating the admin user"
    end
  end

  def recreate_admin!
    u=users.find_by_username('district_admin')
    u.destroy if u
    create_admin_user
    'district_admin recreated'
  end

  def roles_with_system
    roles + Role.system
  end

  def delete_logo=(value)
    @delete_logo = !value.to_i.zero?
  end

  def delete_logo
    !!@delete_logo
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
    if users.blank?
      u=users.build(:username=>"district_admin", :first_name=>name, :last_name => "Administrator")
      u.reset_password!
      u.roles=Role.find(:all,:conditions=>{:district_id=>nil, :name=>"district_admin"})
      u.save!
    end
  end

  def clear_logo
    self.logo=nil if @delete_logo && !logo.dirty?
  end
end

