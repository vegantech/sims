# == Schema Information
# Schema version: 20090325221606
#
# Table name: student_comments
#
#  id         :integer         not null, primary key
#  student_id :integer
#  user_id    :integer
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentComment do
  before(:each) do
    @valid_attributes = {
      :body => "value for body"
    }
  end

  it "should create a new instance given valid attributes" do
    StudentComment.create!(@valid_attributes)
  end
end
