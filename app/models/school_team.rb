# == Schema Information
# Schema version: 20090623023153
#
# Table name: school_teams
#
#  id         :integer(4)      not null, primary key
#  school_id  :integer(4)
#  name       :string(255)
#  anonymous  :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class SchoolTeam < ActiveRecord::Base
  belongs_to :school
  has_and_belongs_to_many :users

  named_scope :named, {:conditions => {:anonymous => false }}
  validates_presence_of :name, :unless => :anonymous?
end
