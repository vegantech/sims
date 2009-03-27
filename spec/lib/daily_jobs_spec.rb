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

  describe 'run_weekly' do
    it 'should call reset_demo if SIMS_DOMAIN is sims-open.vegantech.com' do
      DailyJobs.should_receive(:reset_demo)
      ::SIMS_DOMAIN="sims-open.vegantech.com"
      DailyJobs.run_weekly
    end

    it 'should not call reset_demo if SIMS_DOMAIN is unset or not sims-open.vegantech.com' do
      DailyJobs.should_not_receive(:reset_demo)
      Object.send(:remove_const,:SIMS_DOMAIN) if defined?SIMS_DOMAIN
      DailyJobs.run_weekly
      SIMS_DOMAIN="something.vegantech.com"
      DailyJobs.run_weekly

    end
  end

  describe 'reset_demo' do
    it 'should destroy all user created data' do
      Intervention.should_receive(:destroy_all)
      CustomFlag.should_receive(:destroy_all)
      Checklist.should_receive(:destroy_all)
      Recommendation.should_receive(:destroy_all)
      PrincipalOverride.should_receive(:destroy_all)
      StudentComment.should_receive(:destroy_all)
      RailmailDelivery.should_receive(:destroy_all) if defined?RailmailDelivery
      DailyJobs.reset_demo
    end


  end
end

