class Right < ActiveRecord::Base
  belongs_to :role

  validates_presence_of :read, :if =>lambda{|r| !r.write?}
  validates_presence_of :write, :if =>lambda{|r| !r.read?}
  
  validates_inclusion_of :controller, :in => AllControllers::NAMES
  

  

end
