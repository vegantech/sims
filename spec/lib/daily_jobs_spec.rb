require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DailyJobs do
  describe 'self.run' do
    it 'should have specs' do
      DailyJobs.run
      pending
    end
  end

  describe 'self.run_weekly' do
    it 'should have spec' do
      DailyJobs.run_weekly
      pending
    end
  end
end

