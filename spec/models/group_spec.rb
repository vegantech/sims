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
    FactoryGirl.create(:group)
  end

  it "shoulld return an array of users when members is called" do
    User.destroy_all
    Group.destroy_all
    Group.members.should == []
    
    g1=FactoryGirl.create(:group,:title=>"Group 1")
    g2=FactoryGirl.create(:group,:title=>"Group 2")
    g3=FactoryGirl.create(:group,:title=>"Group 3")
    g4=FactoryGirl.create(:group,:title=>"Group 4")
    district=FactoryGirl.create(:district)
    u1=FactoryGirl.create(:user, :district=>district)
    u2=FactoryGirl.create(:user, :district=>district)

    g1.users << [u1]
    g2.users << [u2]
#    g3.users << User.all

    Group.members.should == [u1,u2]
  

  end

  it 'should not allow titles beginning with pg- ' do
    pg = Group.new :title => 'pg- woo!'
    pg.should_not be_valid
    pg.should have_at_least(1).error_on(:title)
  end
  
end
