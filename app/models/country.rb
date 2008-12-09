# == Schema Information
# Schema version: 20081208201532
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
  
end
