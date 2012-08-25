require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AutomatedIntervention do
  it 'should report a file with incorrect headers' do
    importer=AutomatedIntervention.new File.new('README'),User.new
    importer.import.join.should =~ /Invalid headers: They must be #{AutomatedIntervention::FORMAT}/
  end

  describe 'successful upload' do
    before(:all) do
      @user=Factory(:user)
      stu=Factory(:student,:district_id => @user.district_id).update_attribute(:district_student_id,'cuke123')
      InterventionDefinition.delete_all
      Intervention.delete_all
      InterventionComment.delete_all
      ProbeDefinition.delete_all
      pd=Factory(:probe_definition, :minimum_score=>0,:district_id => @user.district_id)
      ProbeDefinition.update_all("id = 99876", "id = #{pd.id}")

      int_def = Factory(:intervention_definition, :title => 'cuke1', :description => 'cuke1' )
      InterventionDefinition.update_all("id = 99876", "id = #{int_def.id}")
      GoalDefinition.update_all("district_id = #{@user.district_id}")
      @importer=AutomatedIntervention.new File.new('test/csv/automated_intervention/sample.csv'), @user
      @importer.import

    end
    it 'should return the proper messages' do
      expected_messages =
      [
          "Processing file", "4 interventions added",
          "Unknown student with district_student_id invalid123",
          "Invalid Intervention Definition ID -1",
          "Duplicate entry for cuke123,99876,2008-01-02,\"\",\"\",\"\",\"\",This is a duplicate intervention that should not be added.\n",
          "End date Must be after start date cuke123,99876,2008-01-02,2008-01-01,\"\",\"\",This is another intervention on a different date and an invalid end date\n",
          "Score is not between 0 and Infinity cuke123,99876,2008-01-03,2008-01-04,99876,-1000,This is an intervention with an valid probe assignment but invalid score\n",
          "Invalid Probe Definition ID cuke123,99876,2008-01-03,2008-01-04,-1,10,This is an intervention with an invalid probe assignment\n"

      ]
      @importer.messages.should =~ expected_messages


    end

    it 'should have created the first intervention in the file'  do
      intervention=InterventionComment.find_by_comment("This is a comment").intervention
      intervention.start_date.to_s.should == '2008-01-01'
      intervention.should be_active
    end

    it 'should have created the second intervention in the file' do
      intervention=InterventionComment.find_by_comment("This is another intervention on a different date").intervention
      intervention.start_date.to_s.should == '2008-01-02'
      intervention.end_date.to_s.should == '2008-01-03'
      intervention.should_not be_active
    end

    it 'should have created the intervention with the blank score' do
      intervention=InterventionComment.find_by_comment("This is an intervention with an valid probe assignment and blank score").intervention
      intervention.start_date.to_s.should == '2008-01-04'
      intervention.should be_active

    end

    it 'should have created the intervention with the valid score' do
      intervention=InterventionComment.find_by_comment("This is an intervention with an valid probe assignment and valid score").intervention
      intervention.start_date.to_s.should == '2008-01-05'
      intervention.should be_active

    end



  end


end

