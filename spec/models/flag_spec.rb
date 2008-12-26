# == Schema Information
# Schema version: 20081223233819
#
# Table name: flags
#
#  id          :integer         not null, primary key
#  category    :string(255)
#  user_id     :integer
#  district_id :integer
#  student_id  :integer
#  reason      :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Flag do
  before(:each) do
    @valid_attributes = {
      :category => "attendance",
      :reason => "value for reason",
      :type => "value for type"
    }
  end

  it "should create a new instance given valid attributes" do
    Flag.create!(@valid_attributes)
  end
end
