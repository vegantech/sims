# == Schema Information
# Schema version: 20081111204313
#
# Table name: users
#
#  id           :integer         not null, primary key
#  username     :string(255)
#  passwordhash :binary
#  first_name   :string(255)
#  last_name    :string(255)
#  district_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before do
    @user = Factory(:user,:username=>"oneschool")
  end
  describe 'authenticate' do
    it 'should find user with valid login and password' do
      u = User.authenticate('oneschool', 'oneschool')
      u.username.should == 'oneschool'
    end
  
    it 'should not allow bad password' do
      User.authenticate('oneschool', 'badpass').should be_nil
    end
  
    it 'should not allow bad login' do
      User.authenticate('doesnotexist', 'ignored').should be_nil
    end
  end
  
  describe 'passwordhash' do
    it 'should be stored encrypted' do
      @user.passwordhash.should == User.encrypted_password('oneschool')
    end
  end
  
  describe 'full_name' do
    User.new(:first_name=>"0First.", :last_name=>"noschools").fullname.should == ("0First. noschools")
  end
  
  describe 'full_name_last_first' do
    User.new(:first_name=>"0First.", :last_name=>"noschools").fullname_last_first.should == ("noschools, 0First.")
  end

  describe 'authorized_groups_for_school' do
    it 'should have some specs for this method' do
      pending
    end
  end
  
  describe 'filtered_groups_by_school' do
    it 'should have some specs for this method' do
      pending
    end
  end
 
  describe 'filtered_members_by_school' do
    it 'should have some specs for this method' do
      pending
    end
  end

  describe 'authorized enrollments for school' do
    it 'should have some specs for this method' do
      pending
    end
  end

  describe 'authorized schools' do
    it 'should have some specs for this method' do
      pending
    end
  end


  describe 'authorized_ for' do 
    it 'should return false if unknown action_group_type' do
      User.new().authorized_for?('','unknown_group_not_write_or_read').should == false
    end

    it 'should call check for read rights when group is read' do
      Role.should_receive(:has_controller_and_action_group?).with('test_controller','read').and_return(true)
      User.new.authorized_for?('test_controller','read').should == true
      
      
    end

    it 'should call check for write rights when group is write' do
      
      Role.should_receive(:has_controller_and_action_group?).with('test_controller','write').and_return(true)
      User.new.authorized_for?('test_controller','write').should == true
 
    end
    
  end







end
