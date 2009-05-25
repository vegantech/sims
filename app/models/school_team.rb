class SchoolTeam < ActiveRecord::Base
  belongs_to :school
  has_and_belongs_to_many :users

  named_scope :named, {:conditions => {:anonymous => false }}
  validates_presence_of :name, :unless => :anonymous?
end
