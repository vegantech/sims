# == Schema Information
# Schema version: 20101101011500
#
# Table name: tiers
#
#  id          :integer(4)      not null, primary key
#  district_id :integer(4)
#  title       :string(255)
#  position    :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tier do
  before(:each) do
    @valid_attributes = {
      title: "value for title",
      position: "1"
    }
  end

  it "should create a new instance given valid attributes" do
    Tier.create!(@valid_attributes)
  end

  describe 'used_at_all? method' do
    before do
      Tier.delete_all
      Checklist.destroy_all
      Recommendation.destroy_all
      PrincipalOverride.destroy_all
      @tier = FactoryGirl.create(:tier)
    end

    it 'should return false when the tier is not in use' do
      @tier.used_at_all?.should be_false
    end

    it 'should return true if 1 Checklist that uses this tier' do
      p1 = create_without_callbacks(Checklist)
      @tier.used_at_all?.should be_true
    end

    it 'should return true if 1 PrincipalOverride that uses this tier' do
      po = create_without_callbacks(PrincipalOverride,start_tier: @tier)
      # @tier.used_by.should == [po]
      @tier.used_at_all?.should be_true
    end

    it 'should return true if 1 Principal Override response thatuses this tier' do
      po = create_without_callbacks(PrincipalOverride,end_tier: @tier)
      # @tier.used_by.should == [po]
      @tier.used_at_all?.should be_true
    end

    it 'should return true if 1 Recommendation that uses this tier' do
      recommendation = create_without_callbacks(Recommendation)
      # @tier.used_by.should == [recommendation]
      @tier.used_at_all?.should be_true
    end

 end

  describe 'delete_successor method' do
    describe 'when there are no more tiers' do
      it 'should return nil' do
        Tier.delete_all
        tier = FactoryGirl.create(:tier).delete_successor.should be_nil
      end
    end

    describe 'when there exists a greater tier' do
      it 'should return the next greater tier' do
        t0 = FactoryGirl.create(:tier)
        t1 = FactoryGirl.create(:tier)
        t2 = FactoryGirl.create(:tier)
        t1.delete_successor.should == t2
      end
    end

    describe 'when there only exists a lesser tier' do
      it 'should return the lesser tier' do
        t0 = FactoryGirl.create(:tier)
        t1 = FactoryGirl.create(:tier)
        t1.delete_successor.should == t0
      end
    end
  end

  describe 'move_children_to_delete_successor' do
    it 'should be called before destroy' do
      Tier.delete_all
      t0 = FactoryGirl.create(:tier)
      p1 = create_without_callbacks(Checklist, tier: t0)
      t0.should_receive(:move_children_to_delete_successor)
      t0.destroy
    end

    it 'should move a child checklist and recommendation to the appropriate tier' do
      t0 = FactoryGirl.create(:tier)
      t1 = FactoryGirl.create(:tier)
      p1 = create_without_callbacks(Checklist, tier: t0)
      p2 = create_without_callbacks(Recommendation, tier: t0)
      t0.send(:move_children_to_delete_successor)
      p1.reload.tier.should == t1
      p2.reload.tier.should == t1
    end

    it 'should move a child intervention_definition to the appropriate tier' do
      t0 = FactoryGirl.create(:tier)
      t1 = FactoryGirl.create(:tier)
      intervention_def = create_without_callbacks(InterventionDefinition, tier: t1)
      t1.send(:move_children_to_delete_successor)
      intervention_def.reload.tier.should == t0
    end

    it 'should not be called when the tier is destroyed and not used' do
      t0 = FactoryGirl.create(:tier)
      t0.should_not_receive(:move_children_to_delete_successor)
      t0.destroy
    end

    it 'should move child principal overrides to the appropriate tier' do
      t0 = FactoryGirl.create(:tier)
      t1 = FactoryGirl.create(:tier)
      pos = create_without_callbacks(PrincipalOverride,start_tier: t0)
      poe = create_without_callbacks(PrincipalOverride,end_tier: t0)
      t0.send(:move_children_to_delete_successor)
      pos.reload.start_tier.should == t1
      poe.reload.end_tier.should == t1
    end

    it 'should make sure the changes are scoped' do
      pending
    end
  end
  def create_without_callbacks(o, opts={tier: @tier})
    obj=o.new(opts)
    obj.sneaky_save
    obj
  end
end
