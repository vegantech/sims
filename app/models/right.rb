# == Schema Information
# Schema version: 20090325230037
#
# Table name: rights
#
#  id           :integer         not null, primary key
#  controller   :string(255)
#  read_access  :boolean
#  write_access :boolean
#  role_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Right < ActiveRecord::Base
  belongs_to :role

  validates_presence_of :read_access, :if =>lambda{|r| !r.write_access?}
  validates_presence_of :write_access, :if =>lambda{|r| !r.read_access?}
  
  validates_inclusion_of :controller, :in => AllControllers::NAMES

end
