# == Schema Information
# Schema version: 20081227220234
#
# Table name: countries
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  admin      :boolean
#

class Country < ActiveRecord::Base
  has_many :states
  has_many :news,:class_name=>"NewsItem"

  named_scope :normal, :conditions=>{:admin=>false}
  named_scope :admin, :conditions=>{:admin=>true}

  validates_uniqueness_of :admin, :if=> lambda{|c| c.admin?}   #Only 1 admin country
  validates_presence_of :name,:abbrev
  validates_uniqueness_of :name,:abbrev
  before_destroy :make_sure_there_are_no_states
  after_create :create_admin_state

  delegate :admin_district, :to=> 'states.admin.first'

  def to_s
    name
  end


  

  private
  def make_sure_there_are_no_states
    if states.normal.blank?
      states.destroy_all
      news.destroy_all
    else 
      errors.add_to_base("Have the country admin remove the states first.") 
      false
    end

  end


  def create_admin_state
    states.admin.create!(:name=>"Administration", :abbrev=>"admin", :admin=>true) if states.admin.blank?
  end
end
