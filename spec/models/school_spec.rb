# == Schema Information
# Schema version: 20101101011500
#
# Table name: schools
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  district_school_id :integer(4)
#  id_state           :integer(4)
#  id_country         :integer(4)
#  district_id        :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe School do

  before do
    @school=Factory(:school)
  end

  describe 'quicklist_items' do
    it 'should return the school  and district quicklist items' do
      id1= Factory(:intervention_definition)
      id2= Factory(:intervention_definition)
      district=@school.district
      district.quicklist_interventions << id1
      @school.quicklist_interventions << id2
      @school.quicklist.should == [id1, id2]

    end

  end

   describe 'grades_by_user' do
     it 'should return all grades in school when user has access to 
     all students in the school' do
       user=mock_user
       @school.enrollments= [2,1,3,4].collect{|i| Factory(:enrollment,:grade=>i,:school=>@school)}
       user.should_receive('all_students_in_school?').with(@school).and_return(true)
       @school.grades_by_user(user).should == ['1','2','3','4']

                                  
    end
 
    it 'should not prepend * if there is only one' do
      @school.enrollments.create!(:grade=>'only',:student_id=>-1)
      user=mock_user
      user.stub!( :all_students_in_school? =>  true)
      @school.grades_by_user(user).should == ['only']

    end

    it 'should return subset of grades in the school where there is at least one student that the user has access to' do
      e=[2,1,4,3].collect{|i| Factory(:enrollment,:grade=>i, :school=>@school)}

      @school.enrollments=e
      user=mock_user
      g1 = Factory(:group, :students => [e[2].student], :school => @school)

      user.stub!( :all_students_in_school? =>  false, :group_ids => [g1.id])
      user.stub_association!(:special_user_groups, :grades_for_school=> ['2'])
      @school.grades_by_user(user).should == ['2','4']

    end

  end

   describe 'to_s' do
     it 'should return name' do
       School.new(:name=>"Test School").to_s.should == "Test School"
     end
   end

   describe 'enrollment_years' do
     it 'should return all when empty' do
       School.new.enrollment_years.should == []
     end

    it 'should return the years' do
      sch=Factory(:school)
      sch.enrollments.create!(:grade=>2)
      sch.enrollments.create!(:grade=>2,:end_year => 2009)
      sch.enrollments.create!(:grade=>2,:end_year => 2009)
      sch.enrollments.create!(:grade=>2,:end_year => 2008)
      sch.enrollments.create!(:grade=>2,:end_year => 2009)
      sch.enrollments.create!(:grade=>2,:end_year => 2010)
      sch.enrollments.create!(:grade=>2,:end_year => 2007)
      sch.enrollment_years.should == ['','2007','2008','2009','2010']
    end
   end

   describe 'setting user_school_assignments' do
     before :each do
       @sch=Factory(:school)
       @e1=@sch.user_school_assignments.create!(:user_id=>'1',:admin=>false)
       @e2=@sch.user_school_assignments.create!(:user_id=>'2',:admin=>true)
     end

     it 'should not change existing ones with an empty hash' do
       @sch.update_attribute('user_school_assignments_attributes',{})
       @sch.user_school_assignments.should =~ [@e1, @e2]
     end

     it 'should remove when destroyed' do
       @sch.update_attribute('user_school_assignments_attributes',[{:_destroy => '1', :id => @e1.id}, {:_destroy => '1', :id => @e2.id}])
       @sch.user_school_assignments.should be_empty
     end



     it 'should change existing ones when there are none' do
       @sch.update_attributes('user_school_assignments_attributes'=>[{:id =>@e1.id.to_s,:user_id=>'3'}])
       @e1.reload.user_id.should == 3
       @sch.user_school_assignments.should ==[@e1, @e2]
     end

     it 'should not validate when changing existing to match' do
       @sch.update_attributes('user_school_assignments_attributes'=>[{:id => @e1.id.to_s, :user_id=>'2',:admin=>true},{:id =>  @e2.id.to_s,:user_id=>'2'}])
       @sch.should_not be_valid
       @sch.user_school_assignments.first.errors_on(:admin).should_not be_nil
       @sch.user_school_assignments.first.errors_on(:user_id).should_not be_nil
       @sch.user_school_assignments.last.errors_on(:admin).should_not be_nil
       @sch.user_school_assignments.last.errors_on(:user_id).should_not be_nil
     end

     it 'should add new user_school_assignment' do
       @sch.update_attributes('user_school_assignments_attributes'=>[{:user_id=>1, :admin=>true}]).should be_true
       @sch.user_school_assignments.find_by_user_id_and_admin(1,true).should_not be_nil
       @sch.user_school_assignments[0..1].should == [@e1,@e2]
     end

     it 'should not new user_school_assignment that matches existing ' do
       @sch.update_attributes('user_school_assignments_attributes'=>[{:user_id=>'1', :admin=>false}]).should be_false
       @sch.should_not be_valid
     end

     it 'should not new user_school_assignment that matches changed existing ' do
       @sch.update_attributes({'user_school_assignments_attributes'=>[{:user_id=>1, :admin=>true},
                                                                      {:id => @e1.id.to_s,:admin=>true}]}
                             ).should be_false
       @sch.should_not be_valid
     end


     it 'should not new user_school_assignment that matches itself' do
       @sch.update_attributes('user_school_assignments_attributes'=>
                              [{:user_id=>'3', :admin=>false},{:user_id=>'3', :admin=>false}]).should be_false
       @sch.should_not be_valid
     end


   end

end
