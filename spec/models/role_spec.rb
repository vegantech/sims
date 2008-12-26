# == Schema Information
# Schema version: 20081223233819
#
# Table name: roles
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  district_id :integer
#  state_id    :integer
#  country_id  :integer
#  system      :boolean
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Role do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :position => "1",
      :district_id =>1
    }
  end

  it "should create a new instance given valid attributes" do
    Role.create!(@valid_attributes.merge(:district_id=>1))
  end

        

  describe 'has_controller_and_action_group?' do
    it 'should return nothing when there are no matching controllers and something when there is' do
      r= Role.create!(@valid_attributes.merge(:district_id=>1))
      r.rights.create!(:controller=>'students',:read=>true)
      Role.has_controller_and_action_group?('puppies', 'read').should == false
      Role.has_controller_and_action_group?('students', 'read').should == true
      Role.has_controller_and_action_group?('students', 'write').should == false
      Role.has_controller_and_action_group?('students', 'unknown').should == false
    end
      

  end
end
