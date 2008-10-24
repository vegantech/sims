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
        pending
        enrollment1 = mock_enrollment :grade => '1'
        enrollment2 = mock_enrollment :grade => '2'
        enrollment3 = mock_enrollment :grade => '3'
        enrollments = [enrollment1, enrollment2, enrollment3]
        school = School.new
        school.should_receive(:enrollments).with(:include => :students).and_return(enrollments)

        School.should_receive(:find).with(8).and_return(school)

        search_results = Enrollment.search({:school_id => 8, :grade => '3', :search_type => 'list_all'})
        search_results.should == [enrollment3]
      end
    end

    describe 'passed school_id and partial last name' do
      it 'should return all students whose last name starts with a match' do
        pending
        enrollment1 = mock_enrollment :student => mock_student(:last_name => 'Aagard')
        enrollment2 = mock_enrollment :student => mock_student(:last_name => 'Beauregard')
        enrollment3 = mock_enrollment :student => mock_student(:last_name => 'Beaumeister')
        enrollment4 = mock_enrollment :student => mock_student(:last_name => 'Capitan')
        enrollments = [enrollment1, enrollment2, enrollment3, enrollment4]

        school = School.new
        school.should_receive(:enrollments).with(:include => :students).and_return(enrollments)

        School.should_receive(:find).with(8).and_return(school)

        search_results = Enrollment.search({:school_id => 8, :last_name => 'Beau', :search_type => 'list_all'})

        search_results.should == [enrollment2, enrollment3]
      end
  end

    describe 'passed school_id and partial last name' do
      it 'should only match beginnings of last names' do
        pending
        enrollment1 = mock_enrollment :student => mock_student(:last_name => 'Anderson')
        enrollment2 = mock_enrollment :student => mock_student(:last_name => 'Beausonmeister')
        enrollment3 = mock_enrollment :student => mock_student(:last_name => 'Songstrum')
        enrollments = [enrollment1, enrollment2, enrollment3]

        school = School.new
        school.should_receive(:enrollments).with(:include => :students).and_return(enrollments)

        School.should_receive(:find).with(8).and_return(school)

        search_results = Enrollment.search({:school_id => 8, :last_name => 'son', :search_type => 'list_all'})

        search_results.should == [enrollment3]
      end
    end

  end
end
