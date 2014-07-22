# == Schema Information
# Schema version: 20101101011500
#
# Table name: students
#
#  id                  :integer(4)      not null, primary key
#  district_id         :integer(4)
#  last_name           :string(255)
#  first_name          :string(255)
#  number              :string(255)
#  district_student_id :string(255)
#  id_state            :integer(4)
#  id_country          :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  birthdate           :date
#  esl                 :boolean(1)
#  special_ed          :boolean(1)
#  middle_name         :string(255)
#  suffix              :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Student do
  before do
    @student = Factory(:student, id_state: 1234)
  end

  it "should be valid"

  describe 'extended_profile?' do

     describe 'when file exists' do
       it 'should return true' do
         pending

         @student.extended_profile?.should be_true
       end
     end
     describe 'when file does not exist' do
       it 'should return false' do
         pending
         @student.extended_profile?.should be_false
       end
     end
   end

  describe 'extended_profile=' do
    it 'should set the extended profile for the student on save' do
      pending
      student = FactoryGirl.build(:student)
      @extended_profile = File.open(__FILE__)
      student.extended_profile = @extended_profile
      student.save
      student.extended_profile.should match(/should set the extended profile for the student on save/)
      puts student.extended_profile

    end

  end

  describe 'extended_profile' do
    describe 'when file exists' do
      it 'should return file contents' do
        pending
        File.open(@path, 'w'){|f| f<< 'some content'}
        @student.extended_profile.should == 'some content'
      end
    end
    describe 'when file does not exist' do
      it 'should return nil' do
        @student.extended_profile.should == ''
      end
    end
  end

  describe 'id_state' do
    it 'should be unique' do
      district_in_same_state=Factory(:district)
      student_in_same_state = FactoryGirl.build(:student, district: district_in_same_state, id_state: 1234)
      student_in_same_state.should_not be_valid
      student_in_same_state.errors_on(:id_state).should == ["Student with #{@student.id_state} already exists in #{@student.district}"]
    end

  end

  describe "principals" do
    it "should show principals from groups and special groups" do
      #TODO This is missing test for #355 which didn't work for special groups without district assigned
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
    school = School.create!(name: 'My School', district: mock_district)
    e = Enrollment.create!(grade: '1',school: school, student: mock_student)
    user = User.new
    user.should_receive(:authorized_enrollments_for_school).any_number_of_times.and_return([e])

    Enrollment.student_belonging_to_user?(user).should == true
    end

    it 'should return false if the grade does not contain a student belonging to that user' do
      pending
      school=School.new
      e=Enrollment.create!(grade: '1',school_id: -1,student: mock_student)
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

  describe 'fullname' do
    it 'should include middle initial' do
      Student.new(first_name: 'John', middle_name: 'Alfred', last_name: 'Martin').fullname.should == 'John A. Martin'
    end
  end

  describe 'full_name_last_first' do
    Student.new(first_name: "0First.", last_name: "noschools").fullname_last_first.should == ("noschools, 0First.")
  end

  describe 'max_tier' do
    before do
      @district=@student.district
    end

    it 'should return null if there are no tiers in the district' do
      Tier.create(title: 'ok')
      @student.max_tier.should be_nil
    end

    it 'should return the lowest tier in the district if there are no checklists, recommendations, or principal overrides' do
      low_tier=@district.tiers.create!(title: 'Low')
      middle_tier=@district.tiers.create!(title: 'Middle')
      @student.max_tier.should == low_tier
    end

    it 'should return highest tier from checklists, recommendations, or principal overrides' do
      low_tier=@district.tiers.create!(title: 'Low')
      middle_tier=@district.tiers.create!(title: 'Middle')
      high_tier=@district.tiers.create!(title: 'High')
      Recommendation.should_receive(:max_tier).twice.and_return(middle_tier)
      PrincipalOverride.should_receive(:max_tier).twice.and_return(low_tier)
      @student.max_tier.should == middle_tier

      Checklist.should_receive(:max_tier).and_return(high_tier)
      @student.max_tier.should == high_tier
    end

  end

  describe 'birthdate' do
    let(:student) {FactoryGirl.build(:student)}
    
    it 'should allow a blank birthdate' do
      student.birthdate = ''
      student.should be_valid
    end

    it 'should allow a birthdate set to 0' do
      student.birthdate = '0'
      student.should be_valid
    end

    it 'should allow a birthdate set to nil' do
      student.birthdate = nil
      student.should be_valid
    end

    it 'should not allow an invalid birthdate' do
      student.birthdate = "2000"
      student.birthdate.should be_nil
    end
  end

  describe 'safe_destroy' do
    let(:student) {Factory(:student)}

    it 'should destroy the student with no custom content' do
      student.safe_destroy
      student.should be_destroyed
    end

    it 'should not destroy a student with custom content in the db' do
      Factory(:custom_flag, student: student)
      student.safe_destroy
      student.should_not be_destroyed
    end
  end

end
