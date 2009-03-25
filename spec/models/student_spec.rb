# == Schema Information
# Schema version: 20090325214721
#
# Table name: students
#
#  id                            :integer         not null, primary key
#  district_id                   :integer
#  last_name                     :string(255)
#  first_name                    :string(255)
#  number                        :string(255)
#  id_district                   :integer
#  id_state                      :integer
#  id_country                    :integer
#  created_at                    :datetime
#  updated_at                    :datetime
#  birthdate                     :date
#  esl                           :boolean
#  special_ed                    :boolean
#  extended_profile_file_name    :string(255)
#  extended_profile_content_type :string(255)
#  extended_profile_file_size    :integer
#  extended_profile_updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Student do
  before do
    @student = Factory(:student)
  end

  it "should be valid" do 
  end

  describe "principals" do
    it "should show principals from groups and special groups" do
      pending
    end
  end


  describe 'belongs_to_user?' do
    
    it 'should return false if there are no enrollments in the grade' do
      pending
      Enrollment.delete_all
      Enrollment.student_belonging_to_user?(User.new).should == false
    end

    it 'should return true if the grade contains a student belonging to that user' do 
    pending
      school = School.create!(:name => 'My School', :district => mock_district)
      e = Enrollment.create!(:grade=>'1',:school=>school, :student=>mock_student)
      user = User.new
      user.should_receive(:authorized_enrollments_for_school).any_number_of_times.and_return([e])
    
      Enrollment.student_belonging_to_user?(user).should == true
    end

    it 'should return false if the grade does not contain a student belonging to that user' do
      pending
      school=School.new
      e=Enrollment.create!(:grade=>'1',:school_id=>-1,:student=>mock_student)
      user=User.new
      user.should_receive(:authorized_enrollments_for_school).any_number_of_times.and_return([])
      Enrollment.student_belonging_to_user?(user).should == false
    end
  end


  describe 'latest checklist' do
    it  'there should be specs for both paths see #193 in Lighthouse' do
      pending
    end
  end


  describe 'full_name_last_first' do
    Student.new(:first_name=>"0First.", :last_name=>"noschools").fullname_last_first.should == ("noschools, 0First.")
  end

  describe 'find_checklist' do
    it 'should include the answes and score by default' do
      Checklist.should_receive(:find_by_id).with('55',:include=>{:answers=>:answer_definition}).and_return(mc=mock_checklist(:show_score? => true))
      mc.should_receive(:score_checklist)
      Student.new.find_checklist('55').should ==mc
    end

    it 'should just find if show is false' do
      Checklist.should_receive(:find_by_id).with('55').and_return(mc=mock_checklist())
      Student.new.find_checklist('55', show=false).should == mc
    end


  end


 
     
  





end
