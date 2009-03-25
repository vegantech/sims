# == Schema Information
# Schema version: 20090325214721
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

  describe 'when creating an intervention' do
    describe 'with auto_implementer not set' do
      it 'should not create an intervention_participant' do
        i = Factory(:intervention)
        i.intervention_participants.implementer.should be_empty
      end
    end

    describe 'with auto_implementer set to "1"' do
      it 'should create an implementer' do
        i = Factory(:intervention, :auto_implementer => '1')
        i.intervention_participants.size.should == 2 #Author and participant
      end
    end
  end

  describe 'intervention_probe_assignments' do
    describe 'when invalid' do
      it 'should cause a validation error on the intervention itself' do
        pending
        i = Factory(:intervention)
        i.intervention_probe_assignments.build(:end_date => Date.new(2004, 1, 1), :first_date => Date.new(2009, 1, 1))
        i.valid?.should be_false

        ipa = i.intervention_probe_assignments.first
        ipa.end_date = Date.new(2009, 2, 2)
        i.save!
        i.should be_valid

        i.reload 
        i.update_attributes(:intervention_probe_assignment => {'first_date(1i)' => '2009', 'first_date(2i)' => '1', 'first_date(3i)' => '1',
          'end_date(1i)' => '2004', 'end_date(2i)' => '1', 'end_date(3i)' => '1', 'probe_definition_id' => 2}).should be_false
      end
    end
  end

  describe 'build_custom_probe' do
    it 'should create a probe definition which gets assigned to this intervention and recommended to the intervention
    definition when saved' do
      pending
      i = Factory(:intervention)
      p = i.build_custom_probe(:title => "test", :description => "test")
      p.save!
      
      i.reload
      i.intervention_definition.probe_definitions.first.should == p
      i.intervention_probe_assignments.first.probe_definition.should == p
    end
  end

  it "should create a new instance given valid attributes" do
      i = Factory(:intervention)
  end

  it "should end an intervention" do
    i = Factory(:intervention)
    i = Intervention.find(:first)
    i.end(1)
    i.reload
    i.active.should ==(false)
    i.ended_by_id.should ==(1)
    i.ended_at.should == Date.today
  end
end
