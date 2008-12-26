# == Schema Information
# Schema version: 20081223233819
#
# Table name: enrollments
#
#  id         :integer         not null, primary key
#  school_id  :integer
#  student_id :integer
#  grade      :string(16)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Enrollment do

  describe 'search class method' do

    describe 'with student group' do 
      it 'should return only students in that grade' do
        enrollment1 = mock_enrollment :grade => '1'
        enrollment2 = mock_enrollment :grade => '2'
        enrollment3 = mock_enrollment :grade => '3'
        Enrollment.should_receive(:find).with(:all,:include=>:student).and_return([enrollment1,enrollment2,enrollment3])
        Enrollment.search(:search_type => 'list_all', :grade=>'2').should == [enrollment2]
      end

    end

    describe 'passed no search criteria' do
      it 'should raise an exception' do
        lambda {Enrollment.search}.should raise_error
      end
    end

    describe 'passed list_all' do
      it 'should return all students' do
        enrollments = '7 students'
        Enrollment.should_receive(:find).with(:all,:include=>:student).and_return(enrollments)

        Enrollment.search(:search_type => 'list_all').should == enrollments
      end
    end

    describe 'passed list_all with group' do
      it 'should return students from that group' do
        enrollment1 = mock_enrollment :student => mock_student(:group_ids=>[1])
        enrollment2 = mock_enrollment :student => mock_student(:group_ids=>[2])
        enrollment3 = mock_enrollment :student => mock_student(:group_ids=>[1])
        enrollments = [enrollment1, enrollment2, enrollment3]
        Enrollment.should_receive(:find).with(:all,:include=>:student).and_return(enrollments)

        Enrollment.search(:group_id => '1', :search_type => 'list_all').should == [enrollment1,enrollment3]
      end
    end

    describe 'passed partial last name' do
      it 'should return all students whose last name starts with a match' do
        enrollment1 = mock_enrollment :student => mock_student(:last_name => 'Aagard')
        enrollment2 = mock_enrollment :student => mock_student(:last_name => 'Beauregard')
        enrollment3 = mock_enrollment :student => mock_student(:last_name => 'Beaumeister')
        enrollment4 = mock_enrollment :student => mock_student(:last_name => 'Capitan')
        enrollments = [enrollment1, enrollment2, enrollment3, enrollment4]
        Enrollment.should_receive(:find).with(:all,:include=>:student).and_return(enrollments)

        search_results = Enrollment.search(:last_name => 'Beau', :search_type => 'list_all')

        search_results.should == [enrollment2, enrollment3]
      end

      it 'should only match beginnings of last names' do
        enrollment1 = mock_enrollment :student => mock_student(:last_name => 'Anderson')
        enrollment2 = mock_enrollment :student => mock_student(:last_name => 'Beausonmeister')
        enrollment3 = mock_enrollment :student => mock_student(:last_name => 'Songstrum')
        enrollments = [enrollment1, enrollment2, enrollment3]
        Enrollment.should_receive(:find).with(:all,:include=>:student).and_return(enrollments)

        search_results = Enrollment.search(:last_name => 'son', :search_type => 'list_all')

        search_results.should == [enrollment3]
      end

    end

    describe 'passed not in intervention' do
      it 'should only return students that are not in an intervention' do
        enrollment1 = mock_enrollment :student => mock_student(:interventions => mock_intervention(:active =>[]))
        enrollment2 = mock_enrollment :student => mock_student(:interventions => mock_intervention(:active =>[1,2,3]))
        enrollment3 = mock_enrollment :student => mock_student(:interventions => mock_intervention(:active =>[]))
        enrollments = [enrollment1, enrollment2, enrollment3]
        Enrollment.should_receive(:find).with(:all, :include => :student).and_return(enrollments)

        search_results = Enrollment.search(:search_type => 'no_intervention')
        search_results.should == [enrollment1,enrollment3]
      end
    end

    describe 'passed in active intervention' do
      it 'should only return students that are in an active intervention' do
        enrollment1 = mock_enrollment :student => mock_student(:interventions => mock_intervention(:active=>[]))
        enrollment2 = mock_enrollment :student => mock_student(:interventions => mock_intervention(:active=>[1,2,3]))
        enrollment3 = mock_enrollment :student => mock_student(:interventions => mock_intervention(:active =>[]))
        enrollments = [enrollment1, enrollment2, enrollment3]
        Enrollment.should_receive(:find).with(:all,:include=>:student).and_return(enrollments)

        search_results = Enrollment.search(:search_type => 'active_intervention')
        search_results.should == [enrollment2]
      end

      it 'should return students in an active intervention when no checkboxes selected' do
        enrollment1 = mock_enrollment :student => mock_student(:interventions => mock_intervention(:active=>[]))
        enrollment2 = mock_enrollment :student => mock_student(:interventions => mock_intervention(:active=>[1,2,3]))
        enrollment3 = mock_enrollment :student => mock_student(:interventions => mock_intervention(:active =>[]))
        enrollments = [enrollment1, enrollment2, enrollment3]
        Enrollment.should_receive(:find).with(:all,:include=>:student).and_return(enrollments)

        search_results = Enrollment.search(:search_type => 'active_intervention',:intervention_group=>'ObjectiveDefinition',
                                           :intervention_group_types=>[])
        search_results.should == [enrollment2]
 
      end

      it 'should return students in an active intervention with any of the selected checkboxes' do
        intervention1=mock_intervention()
        intervention1.should_receive(:objective_definition).and_return(mock_objective_definition(:id=>1))
        intervention2=mock_intervention()
        intervention2.should_receive(:objective_definition).and_return(mock_objective_definition(:id=>2))
        intervention3=mock_intervention()
        intervention3.should_receive(:objective_definition).and_return(mock_objective_definition(:id=>3))


        enrollment1 = mock_enrollment :student => mock_student(:interventions => mock_array(:active=>[intervention1] ))
        enrollment2 = mock_enrollment :student => mock_student(:interventions => mock_array(:active=>[intervention2]))
        enrollment3 = mock_enrollment :student => mock_student(:interventions => mock_array(:active =>[intervention3]))
        enrollment4 = mock_enrollment :student => mock_student(:interventions => mock_intervention(:active =>[]))
        enrollments = [enrollment1, enrollment2, enrollment3, enrollment4]
        Enrollment.should_receive(:find).with(:all,:include=>:student).and_return(enrollments)

        search_results = Enrollment.search(:search_type => 'active_intervention',:intervention_group=>'ObjectiveDefinition',
                                           :intervention_group_types=>["1","3"])
        search_results.should == [enrollment1,enrollment3]
 
      end
 
    end

    describe 'passed flagged_intervention' do
      describe 'and some flagged interventions were selected' do
        it 'should return students with any of the selected flagged interventions' do
          e1 = mock_enrollment :student => mock_student(:flags => mock_array(:current => [['attendance', 'attendance_flag']]))
          e2 = mock_enrollment :student => mock_student(:flags => mock_array(:current => [['math', 'math_flag']]))
          e3 = mock_enrollment :student => mock_student(:flags => mock_array(:current => [['suspension', 'suspension_flag']]))
          enrollments = [e1, e2, e3]
          Enrollment.should_receive(:find).with(:all, :include => :student).and_return(enrollments)
    
          search_results = Enrollment.search(:search_type => 'flagged_intervention', :flagged_intervention_types => ['attendance', 'suspension'])
          search_results.should == [e1, e3]
        end
      end

      describe 'and no optional flagged interventions were selected' do
        it 'should return all the flagged enrollments' do
          e1 = mock_enrollment :student => mock_student(:flags => mock_array(:current => [['attendance', 'attendance_flag']]))
          e2 = mock_enrollment :student => mock_student(:flags => mock_array(:current => [['math', 'math_flag']]))
          e3 = mock_enrollment :student => mock_student(:flags => mock_array(:current => [['suspension', 'suspension_flag']]))
          e4 = mock_enrollment :student => mock_student(:flags => mock_array(:current => []))
          enrollments = [e1, e2, e3, e4]
          Enrollment.should_receive(:find).with(:all, :include => :student).and_return(enrollments)
    
          search_results = Enrollment.search(:search_type => 'flagged_intervention', :flagged_intervention_types => [])
          search_results.should == [e1,e2,e3]
        end
      end
    end

  end

  describe 'student_belonging_to_user?' do
    
    it 'should return false if there are no enrollments in the grade' do
      Enrollment.delete_all
      Enrollment.student_belonging_to_user?(User.new).should == false
    end

    it 'should return true if the grade contains a student belonging to that user' do 
      school = School.create!(:name => 'My School', :district => mock_district)
      e = Enrollment.create!(:grade=>'1',:school=>school, :student=>mock_student)
      user = User.new
      user.should_receive(:authorized_enrollments_for_school).any_number_of_times.and_return([e])
    
      Enrollment.student_belonging_to_user?(user).should == true
    end

    it 'should return false if the grade does not contain a student belonging to that user' do
      school=School.new
      e=Enrollment.create!(:grade=>'1',:school_id=>-1,:student=>mock_student)
      user=User.new
      user.should_receive(:authorized_enrollments_for_school).any_number_of_times.and_return([])
      Enrollment.student_belonging_to_user?(user).should == false
    end
  end


end
