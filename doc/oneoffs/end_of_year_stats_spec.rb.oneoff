require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'stringio'
describe EndOfYearStats do
  before do
    @district = Factory(:district)
    @school1= Factory(:school, :district => @district)
    @school2= Factory(:school, :district => @district)
    @int_def = Factory(:intervention_definition)
    @objective_def = @int_def.objective_definition
    @goal_def = @int_def.goal_definition
    @goal_def.update_attribute(:district_id, @district.id)
    @stdout_orig = $stdout
    $stdout = StringIO.new

  end

  after do
    $stdout = @stdout_orig
  end
  describe 'mmsd_schools_with_data' do
   it 'should have other specs'
    it 'should be empty' do
      e=EndOfYearStats.new(:district=>@district)
      e.mmsd_schools_with_data
      $stdout.string.should == "district_school_id,name,id_state,interventions,team_notes,checklists,recommendations,custom_flags,team_consultations,progress_monitor_scores,intervention_comments\n"

    end

  end

  describe 'mmsd_students_with_data' do
   it 'should have other specs'
    it 'should be empty when there is no matching data' do
      e=EndOfYearStats.new(:district=>@district)
      e.mmsd_students_with_data
      $stdout.string.should == "school_name,district_school_id,student_name,district_student_id,number,team_notes,checklists,recommendations,intervention_comments,progress_monitor_scores,\n"
    end
  end


end
