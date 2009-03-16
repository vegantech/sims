# == Schema Information
# Schema version: 20090316004509
#
# Table name: news_items
#
#  id          :integer         not null, primary key
#  text        :text
#  system      :boolean
#  district_id :integer
#  school_id   :integer
#  state_id    :integer
#  country_id  :integer
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
