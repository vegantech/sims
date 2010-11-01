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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewsItem do
  before(:each) do
    @valid_attributes = {
      :text => "value for text",
      :system => true,
    }
  end

  it "should create a new instance given valid attributes" do
    NewsItem.create!(@valid_attributes)
  end
end
