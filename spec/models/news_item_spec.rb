# == Schema Information
# Schema version: 20081208201532
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
