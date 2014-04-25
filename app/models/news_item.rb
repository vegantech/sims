# == Schema Information
# Schema version: 20101101011500
#
# Table name: news_items
#
#  id          :integer(4)      not null, primary key
#  text        :text
#  system      :boolean(1)
#  district_id :integer(4)
#  school_id   :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class NewsItem < ActiveRecord::Base
  belongs_to :district, touch: true
  belongs_to :school, touch: true
  attr_protected :district_id
  include LinkAndAttachmentAssets
  validates_presence_of :text
  scope :system, where(system: true)


  def self.build(args = {})
    new(args.merge(system: true))
  end
end
