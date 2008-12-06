# == Schema Information
# Schema version: 20081205205925
#
# Table name: interventions
#
#  id                         :integer         not null, primary key
#  user_id                    :integer
#  student_id                 :integer
#  start_date                 :date
#  end_date                   :date
#  intervention_definition_id :integer
#  frequency_id               :integer
#  frequency_multiplier       :integer
#  time_length_id             :integer
#  time_length_number         :integer
#  active                     :boolean         default(TRUE)
#  ended_by_id                :integer
#  ended_at                   :date
#  created_at                 :datetime
#  updated_at                 :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Intervention do
  before(:each) do
    @valid_attributes = {
      :start_date => Date.today,
      :end_date => Date.today,
      :frequency_id =>1 ,
      :frequency_multiplier => "1",
      :time_length_id => 1 ,
      :time_length_number => "1",
      :active => true,
      :user=> User.new,
      :intervention_definition => InterventionDefinition.make!,
      :student => Student.new
    }
  end

  

  it "should create a new instance given valid attributes" do
    Intervention.create!(@valid_attributes)
  end

  it "should end an intervention" do
    i=Intervention.create!(@valid_attributes)
    i=Intervention.find(:first)
    i.end(1)
    i.reload
    i.active.should ==(false)
    i.ended_by_id.should ==(1)
    i.ended_at.should == Date.today

  end

end
