class Right < ActiveRecord::Base
  belongs_to :role

  validates_presence_of :read, :if =>lambda{|r| !r.write?}
  validates_presence_of :write, :if =>lambda{|r| !r.read?}
  
  validates_inclusion_of :controller, :in => AllControllers::NAMES

  named_scope :read, :conditions => {:read => true}
  named_scope :write, :conditions => {:write => true}
  

  

end
