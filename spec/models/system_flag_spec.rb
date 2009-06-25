# == Schema Information
# Schema version: 20090623023153
#
# Table name: flags
#
#  id          :integer(4)      not null, primary key
#  category    :string(255)
#  user_id     :integer(4)
#  district_id :integer(4)
#  student_id  :integer(4)
#  reason      :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SystemFlag do
  describe 'summary' do
    it 'should construct the summary' do
      sf = SystemFlag.new(:reason => 'Reason', :created_at => "8/11/09 2:13 pm CST".to_time)
      sf.summary.should == 'Reason on Tue Aug 11 14:13:00 UTC 2009'
    end
  end
end
