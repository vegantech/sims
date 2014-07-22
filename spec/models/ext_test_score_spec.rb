# == Schema Information
# Schema version: 20101101011500
#
# Table name: ext_test_scores
#
#  id         :integer(4)      not null, primary key
#  student_id :integer(4)
#  name       :string(255)
#  date       :date
#  scaleScore :float
#  result     :string(255)
#  enddate    :date
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExtTestScore do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :date => Date.today,
      :scaleScore => 1.5,
      :result => "value for result",
      :enddate => Date.today
    }
  end

  it "should create a new instance given valid attributes" do
    ExtTestScore.create!(@valid_attributes)
  end

  describe '<=> and sorting' do
    it 'should sort on dates when present' do
      days_ago = [4,1,3]
      scores=[]
      to_sort = days_ago.collect{
        |d| scores << ExtTestScore.create!(:date=>d.days.ago)
      }
   
      scores.sort.should == [scores[0],scores[2],scores[1]]
    end

    it 'should sort on names when dates are nil' do
      days_ago = [4,1,3]
      scores=[]
      days_ago.collect{
        |d| scores << ExtTestScore.create!(:date=>d.days.ago, :name =>d.to_s)
      }
      scores << ExtTestScore.create!(:name=>"ZZ LAST")
   
      scores.sort.should == [scores[0],scores[2],scores[1],scores[3]]
    end

  end
end
