require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentSearch do
  def def_hash(args = {})
    {
      :search_type => 'list_all',
      :school => school
    }.merge(args)
  end

  def search_def_hash(opts={})
    StudentSearch.search def_hash(opts)
  end

  let(:school) {FactoryGirl.create :school }

  describe 'year_search' do
    before do
      Enrollment.delete_all
      @e1=school.enrollments.create!(:grade => 2)
      @e2=school.enrollments.create!(:grade => 2, :end_year => 2)
      @e3=school.enrollments.create!(:grade => 2, :end_year => 2)
      @e4=school.enrollments.create!(:grade => 2, :end_year => 3)
    end


    it 'should return the given scope if there is no year' do
      search_def_hash.should =~ [@e1,@e2,@e3,@e4]
    end

    it 'should return the given scope if the year is *' do
      search_def_hash(:year => '*').should =~ [@e1,@e2,@e3,@e4]
    end

    it 'should return just the filtered items' do
      search_def_hash(:year => '').should == [@e1]
      search_def_hash(:year => '2').should == [@e2,@e3]
      search_def_hash(:year => '3').should == [@e4]
      search_def_hash(:year => '4').should == []
    end


  end

  describe 'search class method' do
    it 'should contain and maintain scope' do
      school=FactoryGirl.create(:school)
      Enrollment.create!(:student_id=>999,:school_id=>999,:grade=>"XX")
      school.enrollments.create!(:student_id=>999,:grade=>"XX")
      school.enrollments.size.should ==(1)
      StudentSearch.search({:school_id=>school.id,:search_type=>'list_all'}).size.should == 1
    end

    describe 'with student group' do
      it 'should return only students in that grade' do
        Enrollment.delete_all
        e1,e2,e3 = %w{1 2 3}.collect{|i| Enrollment.create! :grade=>i.to_s, :student_id=>99999, :school_id=>999}
        StudentSearch.search(:search_type => 'list_all', :grade=>'3').should == [e3]
      end
    end

    describe 'with user_id and user' do
      let(:school) {FactoryGirl.create(:school) }
      before do
        Enrollment.delete_all
        group1=FactoryGirl.create(:group,:school_id=>school.id)
        group2=FactoryGirl.create(:group, :school_id=>school.id)
        group3=FactoryGirl.create(:group, :school_id=>school.id)
        @user1=FactoryGirl.create(:user)
        @user2=FactoryGirl.create(:user)
        student1=FactoryGirl.create(:student, :esl=>true, :special_ed => true)
        student2=FactoryGirl.create(:student, :esl=>false, :special_ed => false)
        student3=FactoryGirl.create(:student)
        student1.groups << group1
        student2.groups << group2
        student3.groups << group3
        group1.users  << @user1
        group2.users << [@user1,@user2]
        group3.users << @user2
        @e1 = student1.enrollments.create!(:grade=>"1",:school_id=>school.id)
        @e2 = student2.enrollments.create!(:grade=>"1",:school_id=>school.id)
        @e3 = student3.enrollments.create!(:grade=>"1",:school_id=>school.id)
        @group2=group2
      end
      it 'should filter correctly' do
        StudentSearch.search(:search_type=>'list_all').should == [@e1,@e2,@e3]
        StudentSearch.search(:search_type=>'list_all',:user_id=>@user2.id.to_s, :school_id=>school.id).should == [@e2, @e3]
        StudentSearch.search(:search_type=>'list_all',:user=>@user1, :school_id=>school.id).should == [@e1, @e2]
        StudentSearch.search(:search_type=>'list_all',:user => @user1, :user_id=>@user2.id.to_s, :school_id=>school.id).should == [@e2]
        StudentSearch.search(:search_type=>'list_all',:user => @user1, :user_id=>@user2.id.to_s, :school_id=>school.id,:group_id=>@group2.id.to_s).should == [@e2]
      end

      it 'should restrict to a user with access to all students but filtering to him/herself #607' do

        @user1.update_attribute(:all_students, true)
        StudentSearch.search(:search_type=>'list_all',:user => @user1, :user_id=>@user1.id.to_s, :school_id=>school.id).should == [@e1,@e2]
        @user1.update_attribute(:all_students, false)
      end
    end

    describe 'with index_includes' do
      it 'should return proper esl and special_ed values [ LH #570 ]  associations are preloaded in controller for now' do

        Enrollment.delete_all
        student1=FactoryGirl.create(:student, :esl=>true, :special_ed => true, :last_name => 'A')
        student2=FactoryGirl.create(:student, :esl=>false, :special_ed => false, :last_name => 'B')
        @e1 = student1.enrollments.create!(:grade=>"1",:school_id=>999)
        @e2 = student2.enrollments.create!(:grade=>"1",:school_id=>999)
        res= StudentSearch.search(:search_type=>'list_all',:index_includes=>true,:school_id => 999)
        res.first.esl.should == true
        res.first.special_ed.should == true
        res.last.esl.should == false
        res.last.special_ed.should == false


      end


    end

    describe 'passed no search criteria' do
      it 'should return an empty array' do
        StudentSearch.search({}).should == []
        StudentSearch.search(:search_type => 'fake').should == []
      end
    end

    describe 'passed list_all' do
      it 'should return all students' do
        Enrollment.delete_all
        enrollments=(1..8).collect{|i| Enrollment.create! :grade=>i.to_s, :student_id=>99999, :school_id=>999}
        StudentSearch.search(:search_type => 'list_all').should == enrollments
      end
    end

    describe 'passed list_all with group' do
      it 'should return students from that group' do
        g1 = FactoryGirl.create(:group)
        g2 = FactoryGirl.create(:group)

        e1,e2,e3 =(1..3).collect do |i|
          s=FactoryGirl.create(:student)
          s.group_ids = [i.even? ? g2.id : g1.id ]
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end

        StudentSearch.search(:group_id => g1.id.to_s, :search_type => 'list_all').should == [e1,e3]
      end
    end

    describe 'passed partial last name' do
      it 'should return all students whose last name starts with a match' do
        e1, e2, e3, e4 = %w(Aagard Beauregard Beaumeister Capitan).collect do |n|
          s=FactoryGirl.create(:student,:last_name=>n)
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end

        search_results = StudentSearch.search(:last_name => 'Beau', :search_type => 'list_all')

        search_results.should == [e2,e3]
      end

      it 'should only match beginnings of last names' do
        e1, e2, e3 = %w(Anderson Beausonmeister Songstrum).collect do |n|
          s=FactoryGirl.create(:student,:last_name=>n)
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end

        search_results = StudentSearch.search(:last_name => 'son', :search_type => 'list_all')
        search_results.should == [e3]
      end
    end

    describe 'with or without interventions' do
      before do
        Enrollment.delete_all
        @e1,@e2,@e3 =(1..3).collect do |_i|
          s=FactoryGirl.create(:student)
          s.enrollments.create!(:grade=>"1",:school_id=>999)
        end
        FactoryGirl.create(:intervention,:student=>@e1.student,:active=>false)
        FactoryGirl.create(:intervention,:student=>@e2.student,:active=>true)
      end

      describe 'passed not in intervention' do
        it 'should only return students that are not in an intervention' do
          search_results = StudentSearch.search(:search_type => 'no_intervention')
          search_results.should == [@e1,@e3]
        end
      end

      describe 'passed in active intervention' do
        it 'should only return students that are in an active intervention' do
          search_results = StudentSearch.search(:search_type => 'active_intervention')
          search_results.should == [@e2]
        end

        it 'should return students in an active intervention when no checkboxes selected' do
          search_results = StudentSearch.search(:search_type => 'active_intervention',:intervention_group=>'ObjectiveDefinition',
                                             :intervention_group_types=>[])
          search_results.should == [@e2]
        end

        it 'should return students in an active intervention with any of the selected checkboxes' do
          ob2=@e2.student.interventions.first.objective_definition.id.to_s
          FactoryGirl.create(:intervention,:student=>@e3.student,:active=>true)
          ob3 = @e3.student.interventions.first.objective_definition.id.to_s

          @e4 = FactoryGirl.create(:student).enrollments.create!(:grade=>"1",:school_id=>999)
          FactoryGirl.create(:intervention,:student=>@e4.student,:active=>true)

          search_results = StudentSearch.search(:search_type => 'active_intervention',:intervention_group=>'ObjectiveDefinition',
                                             :intervention_group_types=>[ob2,ob3])

          search_results.should == [@e2,@e3]
        end
      end
    end

    describe 'passed flagged_intervention' do
      before do
        Enrollment.delete_all
        @e1,@e2,@e3,@e4,@e5,@e6 =(1..6).collect do |_i|
          s = FactoryGirl.create(:student)
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

          search_results = StudentSearch.search( :search_type => 'flagged_intervention',
            :flagged_intervention_types => ['attendance', 'suspension'])

          search_results.should == [@e1, @e3]

          search_results = StudentSearch.search( :search_type => 'flagged_intervention',
            :flagged_intervention_types => ['attendance', 'ignored'])
          search_results.should == [@e4, @e5]

          search_results = StudentSearch.search( :search_type => 'flagged_intervention',
            :flagged_intervention_types => ['ignored'])
          search_results.should == [@e1,@e4, @e5]
        end
      end

      describe 'and no optional flagged interventions were selected' do
        it 'should return all the flagged enrollments' do
          search_results = StudentSearch.search( :search_type => 'flagged_intervention', :flagged_intervention_types => [])
          search_results.should == [@e1,@e2,@e3]
        end
      end
    end

    describe 'personal_group' do
      let(:pg) {PersonalGroup.create :name => 'test'}
      let! (:in_group) {FactoryGirl.create(:student, :district => school.district, :personal_groups => [pg])}
      let! (:out_group) {FactoryGirl.create(:student, :district => school.district)}
      it 'should return no students' do
        e1 = school.enrollments.create!(:student => in_group, :grade => '1')
        e2 = school.enrollments.create!(:student => out_group, :grade => '1')
        search_def_hash(:group_id => "pg#{pg.id}}").should =~ [e1]
      end
    end
  end
end
