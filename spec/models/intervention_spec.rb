# == Schema Information
# Schema version: 20081227220234
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


  describe 'build_custom_probe' do
    it 'should create a probe definition which gets assigned to this intervention and recommended to the intervention
    definition when saved' do
      i=Factory(:intervention)
      p=i.build_custom_probe(:title=>"test",:description=>"test")
      p.save!
      i.intervention_definition.probe_definitions.first.should == p
      i.intervention_probe_assignments.first.probe_definition.should == p
    end

      




  end

  it "should create a new instance given valid attributes" do
      i=Factory(:intervention)
  end

  it "should end an intervention" do
      i=Factory(:intervention)
    i=Intervention.find(:first)
    i.end(1)
    i.reload
    i.active.should ==(false)
    i.ended_by_id.should ==(1)
    i.ended_at.should == Date.today

  end

end
