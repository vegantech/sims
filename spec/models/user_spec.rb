# == Schema Information
# Schema version: 20081030035908
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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :users, :schools

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
      u = users(:oneschool)
      u.passwordhash.should == User.encrypted_password('oneschool')
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






end
