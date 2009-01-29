require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StudentInterventionsReport do

	describe 'for student with no interventions' do
		it 'should say has no interventions' do
			@report = StudentInterventionsReport.render_text(:student => mock_student(0))
			@report.should match(/Joe Smith \(16\) has no interventions\./)
		end
	end

	describe 'for student with one intervention' do
		before :each do
		 @report = StudentInterventionsReport.render_text(:student => mock_student(1, 2))
		end

		it 'should say has 1 intervention' do
			@report.should match(/Joe Smith \(16\) has 1 intervention\./)
		end

		it 'should show intervention model information' do
			@report.should match(/Goal Title 1/)
			@report.should match(/Objective Title 1/)
			@report.should match(/Category Title 1/)
			@report.should match(/Intervention Definition Title 1/)
			@report.should match(/Intervention Definition Desc 1/)
			@report.should match(/08\/20\/08/)
			@report.should match(/09\/20\/08/)
			@report.should match(/3 times weekly/)
			@report.should match(/1 month/)
			@report.should match(/Ender Wiggin/)
			@report.should match(/09\/18\/08/)
			@report.should match(/09\/19\/08/)
			@report.should match(/Tier - 1/)
		end

		it 'should show participant information' do
			# include participants list and designate implementor	-- intervention_people	 -> users
			# find the relationship inverted in user_interventions_report.rb...
			@report.should match(/\*Participant 1\*/)
			@report.should match(/Participant 2/)
		end

		# included selected monitors and their associated scores.
		# (groupings involved here) --intervention_probe_definitions -> [probe_definition, probes]
		it 'should show selected monitors' do
			verify_probe_definition 1
			verify_probe_definition 2
		end
	end

	def verify_probe_definition n
		# @report.should match(/Probe Def Title #{n}/)
		# @report.should match(/PD Descr #{n}/)
		# @report.should match(/1#{n}/) # minimum_score
		# @report.should match(/2#{n}/) # maximum_score
#		@report.should match(/0#{n}\/1#{n}\/2008/) # first_date
#		@report.should match(/0#{n}\/2#{n}\/2008/) # last_date
		# should we test InterventionProbeDefinition#disabled? here?
	end

	describe 'for student with two interventions' do
		it 'should say has 2 interventions' do
			@report = StudentInterventionsReport.render_text(:student => mock_student(2))
			@report.should match(/Joe Smith \(16\) has 2 interventions\./)
		end
	end

	private

	def mock_student(n_interventions = 1, n_participants = 0)
		student = Student.new :first_name => 'Joe', :last_name => 'Smith', :number => '16'

		1.upto(n_interventions) {|i| student.interventions << mock_an_intervention(i, n_participants) }
		student
	end

	def mock_an_intervention(n = 1, n_participants = 0)
		mock_goal_def = mock_model(GoalDefinition, :title => "Goal Title #{n}")
		mock_obj_def = mock_model(ObjectiveDefinition, :title => "Objective Title #{n}", :goal_definition => mock_goal_def)
		mock_int_clust = mock_model(InterventionCluster, :title => "Category Title #{n}", :objective_definition => mock_obj_def)

		mock_int_def = mock_model(InterventionDefinition, :title => "Intervention Definition Title #{n}", :intervention_cluster => mock_int_clust,
			:description => "Intervention Definition Desc #{n}", :tier_summary => "Tier - #{n}")

		mock_ended_teacher = User.new(:first_name => 'Ender', :last_name => 'Wiggin')
		intervention_people = mock_intervention_people n_participants

		mock_intervention(
							:save => true,
							:intervention_definition => mock_int_def,
							:start_date => '08/20/08',
							:end_date => '09/20/08',
							:frequency_summary => '3 times weekly',
							:time_length_summary => '1 month',
							:ended_by => mock_ended_teacher,
							:ended_at => '09/18/08',
							:updated_at => '09/19/08',
							:intervention_participants => intervention_people,
							:intervention_probe_definitions => mock_intervention_probe_assignments(2))
	end

	def mock_intervention_people num_people
		(1..num_people).to_a.map do |p|
			mock_participant_user = mock_model(User, :fullname => "Participant #{p}")
			mock_intervention_participant(:user => mock_participant_user, :role_id => (p - 1))
		end
	end

	def mock_intervention_probe_assignments n_ipds
		(1..n_ipds).to_a.map{|n| mock_intervention_probe_assignment(:first_date => "0#{n}/1#{n}/08", :last_date => "0#{n}/2#{n}/08")}
	end
end