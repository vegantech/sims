require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Enrollment do

  describe 'search class method' do

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

    describe 'passed list_all with grade' do
      it 'should return students from that grade' do
        enrollment1 = mock_enrollment :grade => '1'
        enrollment2 = mock_enrollment :grade => '2'
        enrollment3 = mock_enrollment :grade => '3'
        enrollments = [enrollment1, enrollment2, enrollment3]
        Enrollment.should_receive(:find).with(:all,:include=>:student).and_return(enrollments)

        Enrollment.search(:grade => '3', :search_type => 'list_all').should == [enrollment3]
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
    end

    # describe 'passed flagged_intervention' do
    #   it 'should return students with any of the selected flagged interventions' do
    #     e1 = mock_enrollment :student => mock_student(:flags => [])
    #     e2 = mock_enrollment :student => mock_student(:flags => [])
    #     e3 = mock_enrollment :student => mock_student(:flags => [])
    #     enrollments = [e1, e2, e3]
    #     Enrollment.should_receive(:find).with(:all, :include => :student).and_return(enrollments)
    # 
    #     search_results = Enrollment.search(:search_type => 'flagged_intervention')
    #     search_results.should == [e1, e3]
    #   end
    # end

  end

end