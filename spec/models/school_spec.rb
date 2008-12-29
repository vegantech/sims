# == Schema Information
# Schema version: 20081227220234
#
# Table name: schools
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  id_district :integer
#  id_state    :integer
#  id_country  :integer
#  district_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe School do

  before do
    @school=Factory(:school)
  end

  describe 'quicklist_items' do
    it 'should return the school  and district quicklist items' do
      pending "otherwise it's just a has many."
    end

  end

   describe 'grades_by_user' do
     it 'should return all grades in school when user has access to 
     all students in the school and add a * when there is more than one' do
       user=mock_user
       special_group = mock_array
       user.should_receive('special_user_groups').and_return(special_group)
       @school.enrollments= [2,1,3,4].collect{|i| Factory(:enrollment,:grade=>i,:school=>@school)}
       special_group.should_receive('all_students_in_school?').with(@school).and_return(true)
       @school.grades_by_user(user).should == ['*','1','2','3','4']

                                  
    end
 
    it 'should not prepend * if there is only one' do
      @school.enrollments.create!(:grade=>'only',:student_id=>-1)
      user=mock_user
      user.stub_association!(:special_user_groups, :all_students_in_school? =>  true)
      @school.grades_by_user(user).should == ['only']

    end

    it 'should return subset of grades in the school where there is at least one student that the user has access to' do
      e=[2,1,4,3].collect{|i| Factory(:enrollment,:grade=>i, :school=>@school)}

      @school.enrollments=e
      user=mock_user
      user.stub_association!(:special_user_groups, :all_students_in_school? =>  false)
      user.stub!(:authorized_enrollments_for_school=>[e[0],e[2]])


      @school.grades_by_user(user).should == ['*','2','4']

    end

  end
end
