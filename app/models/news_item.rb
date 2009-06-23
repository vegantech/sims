# == Schema Information
# Schema version: 20090623023153
#
# Table name: news_items
#
#  id          :integer(4)      not null, primary key
#  text        :text
#  system      :boolean(1)
#  district_id :integer(4)
#  school_id   :integer(4)
#  state_id    :integer(4)
#  country_id  :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

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
