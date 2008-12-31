# == Schema Information
# Schema version: 20081227220234
#
# Table name: students
#
#  id          :integer         not null, primary key
#  district_id :integer
#  last_name   :string(255)
#  first_name  :string(255)
#  number      :string(255)
#  id_district :integer
#  id_state    :integer
#  id_country  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  birthdate   :date
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







end
