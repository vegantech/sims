require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AutomatedIntervention do
  it 'should report an invalid file' do
    importer=AutomatedIntervention.new File.new('test'),User.new
    importer.import.to_s.should =~ /Invalid headers: They must be #{AutomatedIntervention::FORMAT}/
  end

  it 'should report a file with incorrect headers' do
    importer=AutomatedIntervention.new File.new('README'),User.new
    importer.import.to_s.should =~ /Invalid headers: They must be #{AutomatedIntervention::FORMAT}/
  end

  describe 'successful upload' do
    before(:all) do
      @user=Factory(:user)
      stu=Factory(:student,:district_id => @user.district_id).update_attribute(:district_student_id,'cuke123')
      InterventionDefinition.delete_all
      int_def = Factory(:intervention_definition, :title => 'cuke1', :description => 'cuke1' )
      InterventionDefinition.update_all("id = 99876", "id = #{int_def.id}")
      GoalDefinition.update_all("district_id = #{@user.district_id}")
      @importer=AutomatedIntervention.new File.new('test/csv/automated_intervention/sample.csv'), @user
      @importer.import

    end
    it 'should return the proper messages' do
      expected_messages = 
      [
          "Processing file", "2 interventions added",
          "Unknown student with district_student_id invalid123",
          "Invalid Intervention Definition ID -1",
          "Duplicate entry for #<FasterCSV::Row district_student_id:\"cuke123\" intervention_definition_id:\"99876\" start_date:\"2008-01-02\" comment:\"This is a duplicate intervention that should not be added.\">"
      ].to_set
      @importer.messages.to_set.should == expected_messages


    end

    it 'should have created the first intervention in the file'  do
      InterventionComment.find_by_comment("This is a comment").intervention.end_date.to_s.should == '2008-01-01'

    end

    it 'should have created the second intervention in the file' do
      InterventionComment.find_by_comment("This is another intervention on a different date").intervention.end_date.to_s.should == '2008-01-02'
    end
  end


  #3 cuke123,99876,2008-01-01,"This is a comment"
  #4 cuke123,99876,2008-01-02,"This is another intervention on a different date"
  #5 cuke123,99876,2008-01-02,"This is a duplicate intervention that should not be added."


end

