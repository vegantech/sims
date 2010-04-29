# == Schema Information
# Schema version: 20090623023153
#
# Table name: enrollments
#
#  id         :integer(4)      not null, primary key
#  school_id  :integer(4)
#  student_id :integer(4)
#  grade      :string(16)
#  created_at :datetime
#  updated_at :datetime
#  end_year   :integer(4)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Enrollment do

  describe 'year_search' do
    before do
      Enrollment.delete_all
      @e1=Enrollment.create!(:grade=>2,:school_id=>1)
      @e2=Enrollment.create!(:grade=>2,:end_year=>2, :school_id => 1)
      @e3=Enrollment.create!(:grade=>2, :end_year => 2, :school_id => 1)
      @e4=Enrollment.create!(:grade=>2, :end_year => 3, :school_id => 1)
      @scope = Enrollment.send(:scoped,nil)
    end

    it 'should return the given scope if there is no year' do
      Enrollment.send(:year_search,nil,@scope).should == @scope
    end

    it 'should return the given scope if the year is *' do
      Enrollment.send(:year_search,'*', @scope).should == @scope
    end

    it 'should return just the filtered items' do
      Enrollment.send(:year_search,'', @scope).should == [@e1]
      Enrollment.send(:year_search,'2', @scope).should == [@e2,@e3]
      Enrollment.send(:year_search,'3', @scope).should == [@e4]
      Enrollment.send(:year_search,'4', @scope).should == []
    end


    

  end

  describe 'search class method' do
    it 'should contain and maintain scope' do
      school=Factory.create(:school)
      Enrollment.create!(:student_id=>999,:school_id=>999,:grade=>"XX")
      school.enrollments.create!(:student_id=>999,:grade=>"XX")
      school.enrollments.size.should ==(1)
      Enrollment.search({:school_id=>school.id,:search_type=>'list_all'}).size.should == 1
    end

    describe 'with year' do
      it 'should have call year_search' do
        Enrollment.should_receive(:scoped).and_return(s=mock_object(:scoped=>s))
        Enrollment.should_receive(:year_search).with('*',s).and_return(s)
        Enrollment.search({:year=>'*', :search_type => 'list_all'})
      end
    end

    describe 'with student group' do 
      it 'should return only students in that grade' do
        Enrollment.delete_all
        e1,e2,e3 = %w{1 2 3}.collect{|i| Enrollment.create! :grade=>i.to_s, :student_id=>99999, :school_id=>999}
        Enrollment.search(:search_type => 'list_all', :grade=>'3').should == [e3]
      end
    end

    describe 'with user_id and user' do
      before do
        Enrollment.delete_all
        group1=Factory(:group,:school_id=>999)
        group2=Factory(:group, :school_id=>999)
        group3=Factory(:group, :school_id=>999)
        @user1=Factory(:user)
        @user2=Factory(:user)
        student1=Factory(:student)
        student2=Factory(:student)
        student3=Factory(:student)
        student1.groups << group1
        student2.groups << group2
        student3.groups << group3
        group1.users  << @user1
        group2.users << [@user1,@user2]
        group3.users << @user2
        @e1 = student1.enrollments.create!(:grade=>"1",:school_id=>999)
        @e2 = student2.enrollments.create!(:grade=>"1",:school_id=>999)
        @e3 = student3.enrollments.create!(:grade=>"1",:school_id=>999)
        @group2=group2
      end
      it 'should filter correctly' do
        Enrollment.search(:search_type=>'list_all').should == [@e1,@e2,@e3]
        Enrollment.search(:search_type=>'list_all',:user_id=>@user2.id.to_s, :school_id=>999).should == [@e2, @e3]
        Enrollment.search(:search_type=>'list_all',:user=>@user1, :school_id=>999).should == [@e1, @e2]
        Enrollment.search(:search_type=>'list_all',:user => @user1, :user_id=>@user2.id.to_s, :school_id=>999).should == [@e2]
        Enrollment.search(:search_type=>'list_all',:user => @user1, :user_id=>@user2.id.to_s, :school_id=>999,:group_id=>@group2.id.to_s).should == [@e2]
      end
    end

    describe 'with index_includes' do
      it 'should include student, custom flags, interventions with intervon, flags' do
        #        Enrollment.should_receive(:find).with({:include => {:student => [{:custom_flags=>:user}, {:interventions => :intervention_definition}, {:flags => :user}, {:ignore_flags=>:user} ]}})
        Enrollment.search(:search_type=>'list_all',:index_includes=>true)

      end
      

    end

    describe 'passed no search criteria' do
      it 'should raise an exception' do
        lambda {Enrollment.search}.should raise_error
        lambda {Enrollment.search(:search_type=>'fake')}.should raise_error
      end
    end

    describe 'passed list_all' do
      it 'should return all students' do
        Enrollment.delete_all
        enrollments=(1..8).collect{|i| Enrollment.create! :grade=>i.to_s, :student_id=>99999, :school_id=>999}
        Enrollment.search(:search_type => 'list_all').should == enrollments
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

        Enrollment.search(:group_id => g1.id.to_s, :search_type => 'list_all').should == [e1,e3]
      end
    end

    describe 'passed partial last name' do
      it 'should return all students whose last name starts with a match' do
        e1, e2, e3, e4 = %w(Aagard Beauregard Beaumeister Capitan).collect do |n|
          s=Factory(:student,:last_name=>n)
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end

        search_results = Enrollment.search(:last_name => 'Beau', :search_type => 'list_all')

        search_results.should == [e2,e3]
      end

      it 'should only match beginnings of last names' do
        e1, e2, e3 = %w(Anderson Beausonmeister Songstrum).collect do |n|
          s=Factory(:student,:last_name=>n)
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end

        search_results = Enrollment.search(:last_name => 'son', :search_type => 'list_all')
        search_results.should == [e3]
      end
    end

    describe 'with or without interventions' do
      before do
        Enrollment.delete_all
        @e1,@e2,@e3 =(1..3).collect do |i|
          s=Factory(:student)
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end
        Factory(:intervention,:student=>@e1.student,:active=>false)
        Factory(:intervention,:student=>@e2.student,:active=>true)
      end

      describe 'passed not in intervention' do
        it 'should only return students that are not in an intervention' do
          search_results = Enrollment.search(:search_type => 'no_intervention')
          search_results.should == [@e1,@e3]
        end
      end

      describe 'passed in active intervention' do
        it 'should only return students that are in an active intervention' do
          search_results = Enrollment.search(:search_type => 'active_intervention')
          search_results.should == [@e2]
        end

        it 'should return students in an active intervention when no checkboxes selected' do
          search_results = Enrollment.search(:search_type => 'active_intervention',:intervention_group=>'ObjectiveDefinition',
                                             :intervention_group_types=>[])
          search_results.should == [@e2]
        end

        it 'should return students in an active intervention with any of the selected checkboxes' do
          ob2=@e2.student.interventions.first.objective_definition.id.to_s
          Factory(:intervention,:student=>@e3.student,:active=>true)
          ob3 = @e3.student.interventions.first.objective_definition.id.to_s

          @e4 = Factory(:student).enrollments.create!(:grade=>"1",:school_id=>999)
          Factory(:intervention,:student=>@e4.student,:active=>true)

          search_results = Enrollment.search(:search_type => 'active_intervention',:intervention_group=>'ObjectiveDefinition',
                                             :intervention_group_types=>[ob2,ob3])

          search_results.should == [@e2,@e3]
        end
      end
    end

    describe 'passed flagged_intervention' do
      before do
        Enrollment.delete_all
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

          search_results = Enrollment.search( :search_type => 'flagged_intervention',
            :flagged_intervention_types => ['attendance', 'suspension'])

          search_results.should == [@e1, @e3]

          search_results = Enrollment.search( :search_type => 'flagged_intervention',
            :flagged_intervention_types => ['attendance', 'ignored'])
          search_results.should == [@e4, @e5]

          search_results = Enrollment.search( :search_type => 'flagged_intervention',
            :flagged_intervention_types => ['ignored'])
          search_results.should == [@e1,@e4, @e5]
        end
      end

      describe 'and no optional flagged interventions were selected' do
        it 'should return all the flagged enrollments' do
          search_results = Enrollment.search( :search_type => 'flagged_intervention', :flagged_intervention_types => [])
          search_results.should == [@e1,@e2,@e3]
        end
      end
    end
  end
end
