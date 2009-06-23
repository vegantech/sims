# == Schema Information
# Schema version: 20090623023153
#
# Table name: rights
#
#  id           :integer(4)      not null, primary key
#  controller   :string(255)
#  read_access  :boolean(1)
#  write_access :boolean(1)
#  role_id      :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class Right < ActiveRecord::Base
  belongs_to :role

  validates_presence_of :read_access, :if =>lambda{|r| !r.write_access?}
  validates_presence_of :write_access, :if =>lambda{|r| !r.read_access?}
  
  validates_inclusion_of :controller, :in => AllControllers::NAMES

end
