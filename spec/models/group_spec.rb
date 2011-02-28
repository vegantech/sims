# == Schema Information
# Schema version: 20101101011500
#
# Table name: groups
#
#  id                :integer(4)      not null, primary key
#  title             :string(255)
#  school_id         :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  district_group_id :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Group do
  
  it "should create a new instance given valid attributes" do
    Factory(:group)
  end

  it "shoulld return an array of users when members is called" do
    User.destroy_all
    Group.destroy_all
    Group.members.should == []
    
    g1=Factory(:group,:title=>"Group 1")
    g2=Factory(:group,:title=>"Group 2")
    g3=Factory(:group,:title=>"Group 3")
    g4=Factory(:group,:title=>"Group 4")
    district=Factory(:district)
    u1=Factory(:user, :district=>district)
    u2=Factory(:user, :district=>district)

    g1.users << [u1]
    g2.users << [u2]
#    g3.users << User.all

    Group.members.should == [u1,u2]
  

  end
  
end
