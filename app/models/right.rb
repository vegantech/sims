# == Schema Information
# Schema version: 20081125030310
#
# Table name: rights
#
#  id         :integer         not null, primary key
#  controller :string(255)
#  read       :boolean
#  write      :boolean
#  role_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Right < ActiveRecord::Base
  belongs_to :role

  validates_presence_of :read, :if =>lambda{|r| !r.write?}
  validates_presence_of :write, :if =>lambda{|r| !r.read?}
  
  validates_inclusion_of :controller, :in => AllControllers::NAMES

end
