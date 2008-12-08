class NewsItem < ActiveRecord::Base
  belongs_to :country
  belongs_to :state
  belongs_to :district
  belongs_to :school

  validates_presence_of :text
  named_scope :system, :conditions=>{:system=>true}


  def self.build(args={})
    new(args.merge(:system=>true))
  end
end
