# == Schema Information
# Schema version: 20081227220234
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
  def all_ids
    Enrollment.find(:all,:select=>"id").collect(&:id)
  end


  describe 'search class method' do
    it 'should contain and maintain scope' do
      school=Factory.create(:school)
      Enrollment.create!(:student_id=>999,:school_id=>999,:grade=>"XX")
      school.enrollments.create!(:student_id=>999,:grade=>"XX")
      school.enrollments.size.should ==(1)
      Enrollment.search(school.enrollment_ids,{:search_type=>'list_all'}).size.should == 1
    end

    describe 'with student group' do 
      it 'should return only students in that grade' do
        e1,e2,e3 = %w{1 2 3}.collect{|i| Enrollment.create! :grade=>i.to_s, :student_id=>99999, :school_id=>999}
        Enrollment.search(all_ids,:search_type => 'list_all', :grade=>'2').should == [e2]
      end

    end

    describe 'passed no search criteria' do
      it 'should raise an exception' do
        lambda {Enrollment.search}.should raise_error
      end
    end

    describe 'passed list_all' do
      it 'should return all students' do
        enrollments=(1..8).collect{|i| Enrollment.create! :grade=>i.to_s, :student_id=>99999, :school_id=>999}
        Enrollment.search(all_ids,:search_type => 'list_all').should == enrollments
      end
    end

    describe 'passed list_all with group' do
      it 'should return students from that group' do
        g1 = Factory(:group)
        g2 = Factory(:group)

        e1,e2,e3 =(1..3).collect do |i|
          s=Factory(:student)
          s.group_ids = [i.even? ? g2.id : g1.id ]
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end

        Enrollment.search(all_ids,:group_id => g1.id.to_s, :search_type => 'list_all').should == [e1,e3]
      end
    end

    describe 'passed partial last name' do
      it 'should return all students whose last name starts with a match' do
        e1, e2, e3, e4 = %w(Aagard Beauregard Beaumeister Capitan).collect do |n|
          s=Factory(:student,:last_name=>n)
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end

        search_results = Enrollment.search(all_ids,:last_name => 'Beau', :search_type => 'list_all')

        search_results.should == [e2,e3]
      end

      it 'should only match beginnings of last names' do
        e1, e2, e3 = %w(Anderson Beausonmeister Songstrum).collect do |n|
          s=Factory(:student,:last_name=>n)
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end

        search_results = Enrollment.search(all_ids,:last_name => 'son', :search_type => 'list_all')

        search_results.should == [e3]
      end

    end

    describe 'with or without interventions' do
      before do
        @e1,@e2,@e3 =(1..3).collect do |i|
          s=Factory(:student)
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end
        Factory(:intervention,:student=>@e1.student,:active=>false)
        Factory(:intervention,:student=>@e2.student,:active=>true)
      end
    
      describe 'passed not in intervention' do
        it 'should only return students that are not in an intervention' do
          search_results = Enrollment.search(all_ids,:search_type => 'no_intervention')
          search_results.should == [@e1,@e3]
        end
      end

      describe 'passed in active intervention' do
        it 'should only return students that are in an active intervention' do
          search_results = Enrollment.search(all_ids,:search_type => 'active_intervention')
          search_results.should == [@e2]
        end

        it 'should return students in an active intervention when no checkboxes selected' do
          search_results = Enrollment.search(all_ids,:search_type => 'active_intervention',:intervention_group=>'ObjectiveDefinition',
                                             :intervention_group_types=>[])
          search_results.should == [@e2]
   
        end

        it 'should return students in an active intervention with any of the selected checkboxes' do
          ob2=@e2.student.interventions.first.objective_definition.id.to_s
          Factory(:intervention,:student=>@e3.student,:active=>true)
          ob3=@e3.student.interventions.first.objective_definition.id.to_s
          
          @e4=Factory(:student).enrollments.create!(:grade=>"1",:school_id=>999)
          Factory(:intervention,:student=>@e4.student,:active=>true)

          search_results = Enrollment.search(all_ids,:search_type => 'active_intervention',:intervention_group=>'ObjectiveDefinition',
                                             :intervention_group_types=>[ob2,ob3])
                                                       
          search_results.should == [@e2,@e3]
   
        end
      end
 
    end

    describe 'passed flagged_intervention' do
      before do
        @e1,@e2,@e3,@e4,@e5,@e6 =(1..6).collect do |i|
          s = Factory(:student)
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end

        @e1.student.system_flags.create!(:category => 'attendance', :reason=> 'attendance_flag')
        @e1.student.system_flags.create!(:category => 'math', :reason=> 'math_flag')
        @e1.student.ignore_flags.create!(:category => 'math', :reason=> 'math_flag')
        
        @e2.student.system_flags.create!(:category => 'math', :reason => 'math_flag')
        @e3.student.custom_flags.create!(:category => 'suspension', :reason => 'suspension_flag')

        @e4.student.system_flags.create!(:category => 'attendance', :reason=> 'attendance_flag')
        @e4.student.ignore_flags.create!(:category => 'attendance', :reason=> 'anti-attendance_flag')
        
        @e5.student.ignore_flags.create!(:category => 'attendance', :reason=> 'anti-attendance_flag')
      end

      describe 'and some flagged interventions were selected' do
        it 'should return students with any of the selected flagged interventions' do
    
          search_results = Enrollment.search(all_ids, :search_type => 'flagged_intervention',
           :flagged_intervention_types => ['attendance', 'suspension'])
          search_results.should == [@e1, @e3]


          search_results = Enrollment.search(all_ids, :search_type => 'flagged_intervention',
            :flagged_intervention_types => ['attendance', 'ignored'])
          search_results.should == [@e4, @e5]

          search_results = Enrollment.search(all_ids, :search_type => 'flagged_intervention',
            :flagged_intervention_types => ['ignored'])
          search_results.should == [@e1,@e4, @e5]
        end
      end

      describe 'and no optional flagged interventions were selected' do
        it 'should return all the flagged enrollments' do
          search_results = Enrollment.search(all_ids, :search_type => 'flagged_intervention', :flagged_intervention_types => [])
          search_results.should == [@e1,@e2,@e3]
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
