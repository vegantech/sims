# == Schema Information
# Schema version: 20090524185436
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
  describe 'something' do 
    it 'should' do
      pending 'Remove this, after refactoring'
      e= {"end_date(3i)"=>"25", "start_date(1i)"=>"2009", "apply_to_all"=>"0", "start_date(2i)"=>"4", "auto_implementer"=>"0", "intervention_probe_assignment"=>{"end_date(3i)"=>"25", "probe_definition_id"=>"", "probe_definition"=>{"title"=>"", "minimum_score"=>"", "description"=>"jhj", "maximum_score"=>""}, "frequency_multiplier"=>"2", "first_date(1i)"=>"2009", "first_date(2i)"=>"4", "frequency_id"=>"284292352", "first_date(3i)"=>"26", "end_date(1i)"=>"2009", "end_date(2i)"=>"7"}, "start_date(3i)"=>"26", "frequency_multiplier"=>"1", "time_length_id"=>"503752779", "frequency_id"=>"284292352", "intervention_definition_id"=>"", "comment"=>{"comment"=>""}, "end_date(1i)"=>"2009", "time_length_number"=>"1", "intervention_definition"=>{"title"=>"Custom Intervention Title", "description"=>"Custom Intervention Desc", "tier_id"=>"284451385", "intervention_cluster_id"=>"34708545"}, "end_date(2i)"=>"7"}
      c=ProbeDefinition.count
      i=Intervention.build_and_initialize(e.merge(:user_id=>1,:selected_ids=>1,:school_id=>1))
      id=i.intervention_definition
      id.valid?
      puts id.errors.inspect
      
      i.save #should fail but won't yet
      ProbeDefinition.count.should == c

      #-----Below is just reference
      if false
        @intervention = current_student.interventions.build_and_initialize(params[:intervention].merge(values_from_session))
       ppp= {"commit"=>"Save", "action"=>"create", "authenticity_token"=>"KkZvosXOVNLa0OE9SWx7otNQgilYP39jbwHXqZVtvD4=", "intervention"=>{"end_date(3i)"=>"25", "start_date(1i)"=>"2009", "apply_to_all"=>"0", "start_date(2i)"=>"4", "auto_implementer"=>"0", "intervention_probe_assignment"=>{"end_date(3i)"=>"25", "probe_definition_id"=>"", "probe_definition"=>{"title"=>"", "minimum_score"=>"", "description"=>"jhj", "maximum_score"=>""}, "frequency_multiplier"=>"2", "first_date(1i)"=>"2009", "first_date(2i)"=>"4", "frequency_id"=>"284292352", "first_date(3i)"=>"26", "end_date(1i)"=>"2009", "end_date(2i)"=>"7"}, "start_date(3i)"=>"26", "frequency_multiplier"=>"1", "time_length_id"=>"503752779", "frequency_id"=>"284292352", "intervention_definition_id"=>"", "comment"=>{"comment"=>""}, "end_date(1i)"=>"2009", "time_length_number"=>"1", "intervention_definition"=>{"title"=>"Custom Intervention Title", "description"=>"Custom Intervention Desc", "tier_id"=>"284451385", "intervention_cluster_id"=>"34708545"}, "end_date(2i)"=>"7"}, "controller"=>"interventions"}
       values_from_sess={:user_id => session[:user_id],
             :selected_ids => selected_students_ids,
                   :school_id => session[:school_id]
                 }
      end
    end
  end

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

  it 'should require end_date be after (or same as) start date' do
    i = Factory(:intervention, :start_date => Date.today, :end_date => Date.today + 1.day)
    i.start_date = nil
    i.should_not be_valid
    i.errors_on(:end_date).should_not be_nil
    i.start_date = 5.days.ago
    i.should be_valid
    i.start_date = 5.days.since
    i.should_not be_valid
    i.errors_on(:end_date).should_not be_nil
  end
end
