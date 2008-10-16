require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Enrollment do

	describe 'search class method' do

		describe 'passed no school_id' do
			it 'should default to no enrollments' do
				search_results = Enrollment.search({})
				search_results.should == []
			end
		end

		describe 'passed a school_id' do
			it 'should return students from that school' do
				enrollments = '7 students'
				school = School.new
				school.should_receive(:enrollments).with(:include => :students).and_return(enrollments)
				School.should_receive(:find).with(7).and_return(school)
				search_results = Enrollment.search({:school_id => 7})
				search_results.should == enrollments
			end
		end

		describe 'passed school_id and grade' do
			it 'should return students from that grade in that school' do
				enrollment1 = mock_enrollment :grade => '1'
				enrollment2 = mock_enrollment :grade => '2'
				enrollment3 = mock_enrollment :grade => '3'
				enrollments = [enrollment1, enrollment2, enrollment3]
				school = School.new
				school.should_receive(:enrollments).with(:include => :students).and_return(enrollments)

				School.should_receive(:find).with(8).and_return(school)

				search_results = Enrollment.search({:school_id => 8, :grade => '3'})
				search_results.should == [enrollment3]
			end
		end

		describe 'passed school_id and partial last name' do
			it 'should return all students whose last name starts with a match' do
				enrollment1 = mock_enrollment :student => mock_student(:last_name => 'Aagard')
				enrollment2 = mock_enrollment :student => mock_student(:last_name => 'Beauregard')
				enrollment3 = mock_enrollment :student => mock_student(:last_name => 'Beaumeister')
				enrollment4 = mock_enrollment :student => mock_student(:last_name => 'Capitan')
				enrollments = [enrollment1, enrollment2, enrollment3, enrollment4]

				school = School.new
				school.should_receive(:enrollments).with(:include => :students).and_return(enrollments)

				School.should_receive(:find).with(8).and_return(school)

				search_results = Enrollment.search({:school_id => 8, :last_name => 'Beau'})

				search_results.should == [enrollment2, enrollment3]
			end
		end

		describe 'passed school_id and partial last name' do
			it 'should only match beginnings of last names' do
				enrollment1 = mock_enrollment :student => mock_student(:last_name => 'Anderson')
				enrollment2 = mock_enrollment :student => mock_student(:last_name => 'Beausonmeister')
				enrollment3 = mock_enrollment :student => mock_student(:last_name => 'Songstrum')
				enrollments = [enrollment1, enrollment2, enrollment3]

				school = School.new
				school.should_receive(:enrollments).with(:include => :students).and_return(enrollments)

				School.should_receive(:find).with(8).and_return(school)

				search_results = Enrollment.search({:school_id => 8, :last_name => 'son'})

				search_results.should == [enrollment3]
			end
		end

	end
end
