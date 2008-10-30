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
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'test/unit'


class UserTest < ActiveSupport::TestCase
  fixtures :users
  def test_user_authenticate
    user = User.authenticate("oneschool", "oneschool")
    assert_equal "oneschool", user.username
    assert !User.authenticate("oneschool", "badpass")
    assert !User.authenticate("doesnotexist", "doesnotmatter")
  end
     
  def test_encrypted_password
    user = users(:oneschool)
    assert_equal user.passwordhash, User.encrypted_password("oneschool")
  end


  def test_full_name
    assert_equal User.new(:first_name=>"0First.", :last_name=>"noschools").fullname, ("0First. noschools")
  end

  def test_full_name_last_first
    assert_equal User.new(:first_name=>"0First.", :last_name=>"noschools").fullname_last_first, ("noschools, 0First.")
  end


end
