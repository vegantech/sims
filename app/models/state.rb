# == Schema Information
# Schema version: 20081227220234
#
# Table name: states
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#  admin      :boolean
#

class State < ActiveRecord::Base
  belongs_to :country
  has_many :districts
  has_many :news,:class_name=>"NewsItem"
  named_scope :normal, :conditions=>{:admin=>false}
  named_scope :admin, :conditions=>{:admin=>true}
  
  validates_uniqueness_of :admin, :scope=>:country_id, :if=>lambda{|s| s.admin?}  #only 1 admin state per country
  validates_uniqueness_of :country_id,  :if=>lambda{|s| s.country && s.country.admin?}  #only 1 state per admin country
  validates_presence_of :name,:abbrev, :country
  validates_uniqueness_of :name,:abbrev, :scope=>:country_id
  validates_format_of :abbrev, :with => /\A[0-9a-z]+\Z/i, :message => "Can only contain letters or numbers"


  before_destroy :make_sure_there_are_no_districts
  after_create :create_admin_district
 
  def to_s
    name
  end

  def admin_district
    districts.admin.first
  end

  

private
  def make_sure_there_are_no_districts
    if districts.normal.blank?
      districts.destroy_all
      news.destroy_all
    else 
      errors.add_to_base("Have the state admin remove the districts first.") 
      false
    end

  end

  def create_admin_district
    districts.create!(:name=>"Administration", :abbrev=>"admin", :admin=>true) if districts.admin.blank?
  end
end


