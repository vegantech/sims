class District < ActiveRecord::Base
  belongs_to :state
  has_many :users
  has_many :checklist_definitions
  has_many :goal_definitions, :order=>:position
  has_many :probe_definitions

  GRADES=  %w{ PK KG 01 02 03 04 05 06 07 08 09 10 11 12}

  def grades
    GRADES
  end

end
