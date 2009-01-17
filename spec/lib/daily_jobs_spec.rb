require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CreateInterventionPdfs do
  describe 'self.run' do
    it 'should call other methods' do
      DailyJobs.should_receive(:regenerate_intervention_reports)
      DailyJobs.run
    end

  end

  describe 'self.regenerate_intervention_reports' do
    it 'should call CreateInterventionPdfs.generate for each district' do
      District.should_receive(:all).and_return([1])
      CreateInterventionPdfs.should_receive(:generate).with(1)
      DailyJobs.regenerate_intervention_reports
    end
  end
end

