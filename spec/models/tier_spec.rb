# == Schema Information
# Schema version: 20090428193630
#
# Table name: tiers
#
#  id          :integer         not null, primary key
#  district_id :integer
#  title       :string(255)
#  position    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tier do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    Tier.create!(@valid_attributes)
  end

  describe 'used_by method' do
    def create_without_callbacks(o, opts={:tier=>@tier})
      obj=o.new(opts)
      obj.send(:create_without_callbacks)
      obj
    end
      

    
    before do
      Tier.destroy_all
      Checklist.destroy_all
      Recommendation.destroy_all
      PrincipalOverride.destroy_all
      @tier = Factory(:tier)
    end

    it 'should return nil when the tier is not in use' do
      @tier.used_by.should be_nil
    end

    it 'should return 1 Checklist that uses this tier' do
      p1 = create_without_callbacks(Checklist)
      @tier.used_by.should == [p1]
    end

    it 'should return 1 PrincipalOverride that uses this tier' do
      po = create_without_callbacks(PrincipalOverride,:start_tier => @tier)
      @tier.used_by.should == [po]
    end

    it 'should return 1 Principal Override response thatuses this tier' do
      po = create_without_callbacks(PrincipalOverride,:end_tier => @tier)
      @tier.used_by.should == [po]

    end

    it 'should return 1 Recommendation that uses this tier' do
      recommendation = create_without_callbacks(Recommendation)
      @tier.used_by.should == [recommendation]
    end

    it 'should return 1 of each association that uses this tier' do
      p1 = create_without_callbacks(Checklist)
      pos = create_without_callbacks(PrincipalOverride,:start_tier => @tier)
      poe = create_without_callbacks(PrincipalOverride,:end_tier => @tier)
      recommendation = create_without_callbacks(Recommendation)
      intervention_definition = create_without_callbacks(InterventionDefinition)
      @tier.used_by.to_set.should == [p1, pos, poe, recommendation, intervention_definition].to_set
    end

    it 'should return 1 intervention definition and 1 recommendation that use this tier' do
      
      recommendation = create_without_callbacks(Recommendation)
      intervention_definition = create_without_callbacks(InterventionDefinition)

      #order doesn't matter
      @tier.used_by.to_set.should == [recommendation,intervention_definition].to_set
    end
  end
end
