# == Schema Information
# Schema version: 20101101011500
#
# Table name: district_logs
#
#  id          :integer(4)      not null, primary key
#  district_id :integer(4)
#  body        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DistrictLog do
  before(:each) do
    @valid_attributes = {
      :body => "value for body"
    }
  end

  it "should create a new instance given valid attributes" do
    DistrictLog.create!(@valid_attributes)
  end

  describe 'for_display' do
    before :all do
      @user = FactoryGirl.create :user, username: 'valid_user', first_name: 'First',
                                        middle_name: 'Middle', last_name: 'Last'

      DistrictLog.delete_all

      @blank = DistrictLog.create!
      @mistyped_username = DistrictLog.failure.create! :body => 'mistyped'
      @valid_success = DistrictLog.success.create! user: @user, district: @user.district
      @valid_failure = DistrictLog.failure.create! user: @user, district: @user.district
    end
    describe 'filter' do
      it 'should match all when blank' do
        DistrictLog.for_display({}).should =~ [@blank,
                                               @mistyped_username,
                                               @valid_success,
                                               @valid_failure]
      end

      it 'should match mistyped username' do
        DistrictLog.for_display(filter: 'mistyped').should =~ [@mistyped_username]
      end

      it 'should match valid usernames success and failure' do
        DistrictLog.for_display(filter: 'valid').should =~ [
          @valid_success, @valid_failure]
      end

      it 'should match first + last' do
        DistrictLog.for_display(filter: 'First Last').should =~ [
          @valid_success, @valid_failure]
      end
      it 'should match first + middle initial' do
        DistrictLog.for_display(filter: 'First M').should =~ [
          @valid_success, @valid_failure]
      end

    end
  end

  describe 'record_failure' do
    let!(:district) { FactoryGirl.create :district }
    let(:user) { User.new(first_name: 'Test',
                          last_name: 'User',
                          username: 'test_user',
                          district: district) }
    it 'valid username' do
      res = DistrictLog.record_failure(  "username" => 'test_user',
                                          "district_id_for_login" => district.id 
                                      )
      res.status.should == DistrictLog::FAILURE
      res.district_id.should == district.id
      res.user_id.should == user.id
    end

    it 'invalid username' do
      res = DistrictLog.record_failure(  "username" => 'not_test_user',
                                          "district_id_for_login" => district.id 
                                      )
      res.status.should == DistrictLog::FAILURE
      res.district_id.should == district.id
      res.user.should == nil
    end
  end

  describe 'record_success' do
    let(:district) { FactoryGirl.create :district }
    let(:user) { User.new(first_name: 'Test', last_name: 'User', district: district) }

    it 'should create a district log' do
      res = DistrictLog.record_success user
      res.status.should == DistrictLog::SUCCESS
      res.district_id.should == district.id
      res.user.should == user
    end
  end


  describe 'to_s' do
    let(:user) { User.new first_name: 'Test', last_name: 'User' }

    describe 'success' do
      describe 'with_user' do
        subject { DistrictLog.success.build user: user }
        its(:to_s) { should match("Successful login of Test User") }
      end
      describe 'old log' do
        subject { DistrictLog.success.build body: "Old Body" }
        its(:to_s) { should match("Old Body") }
      end
    end

    describe 'failure' do
        subject { DistrictLog.failure.build body: "test_user" }
        its(:to_s) { should match("Failed login of test_user") }
    end
  end
end
