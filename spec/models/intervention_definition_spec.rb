# == Schema Information
# Schema version: 20101101011500
#
# Table name: intervention_definitions
#
#  id                      :integer(4)      not null, primary key
#  title                   :string(255)
#  description             :text
#  custom                  :boolean(1)
#  intervention_cluster_id :integer(4)
#  tier_id                 :integer(4)
#  time_length_id          :integer(4)
#  time_length_num         :integer(4)      default(1)
#  frequency_id            :integer(4)
#  frequency_multiplier    :integer(4)      default(1)
#  user_id                 :integer(4)
#  school_id               :integer(4)
#  disabled                :boolean(1)
#  position                :integer(4)
#  created_at              :datetime
#  updated_at              :datetime
#  notify_email            :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InterventionDefinition do
  it "should create a new instance given valid attributes" do
    Factory(:intervention_definition)
  end

  describe 'district_quicklist' do
    it 'should return true and false if not if it is a member of the quicklist' do
      k=Factory(:intervention_definition)
      ql=QuicklistItem.create!(:district=>k.district, :intervention_definition => k)
      k.district_quicklist.should == true

      ql.destroy
      k.reload.district_quicklist.should == false
    end

    it 'should assign itself to the quicklist if = "1"' do
      pending
      k=Factory(:intervention_definition)
      k.district_quicklist.should == false
      k.district_quicklist = "1"
      k.save
      k.district.quicklist_items.first.intervention_definition.should == k
      k.district_quicklist.should == true
    end

    it 'should assign itself to the quicklist even when new' do
      iid=Factory.build(:intervention_definition, :district_quicklist=>'1')
      iid.save
      
    end

    it 'should remove itself from the quicklist if = false' do
      k=Factory(:intervention_definition)
      k.district_quicklist ="1"
      k.save
      k.district_quicklist ="0"
      k.save
      k.district_quicklist.should == false
      k.district.quicklist_items.should == []
      k.reload
      k.district_quicklist =false
      k.district_quicklist.should == false
    end
  end



  describe 'restrict_tiers_and_disabled' do
    before do
      Tier.delete_all
      InterventionDefinition.delete_all
      @id1=Factory(:intervention_definition)
      @id2=Factory(:intervention_definition, :intervention_cluster => @id1.intervention_cluster)
      @id3=Factory(:intervention_definition, :intervention_cluster => @id1.intervention_cluster, :disabled=>true)
      @district = @id1.district
      @tier1=@district.tiers.create!(:title => 'tier 1')
      @tier2=@district.tiers.create!(:title => 'tier 2')
      @id1.update_attribute(:tier_id, @tier1.id)
      @id2.update_attribute(:tier_id, @tier2.id)
    end

    it 'should show all when there are no restrictions' do
      InterventionDefinition.restrict_tiers_and_disabled(@tier1).should == [@id1,@id2]
      @id1.intervention_cluster.intervention_definitions.restrict_tiers_and_disabled(@tier1).should == [@id1,@id2]
    end

    it 'should restrict when the district lock tiers' do
      @district.toggle!(:lock_tier)
      InterventionDefinition.restrict_tiers_and_disabled(@tier1).should == [@id1]
      @id1.intervention_cluster.intervention_definitions.restrict_tiers_and_disabled(@tier1).should == [@id1]
    end

    it 'should allow when the district lock tiers but exemptions are in place' do
      @district.toggle!(:lock_tier)
      #goal definition
      @id1.goal_definition.toggle!(:exempt_tier)
      InterventionDefinition.restrict_tiers_and_disabled(@tier1).should == [@id1,@id2]
      @id1.intervention_cluster.intervention_definitions.restrict_tiers_and_disabled(@tier1).should == [@id1,@id2]
      @id1.goal_definition.toggle!(:exempt_tier)
      #objective definition
      @id1.objective_definition.toggle!(:exempt_tier)
      InterventionDefinition.restrict_tiers_and_disabled(@tier1).should == [@id1,@id2]
      @id1.intervention_cluster.intervention_definitions.restrict_tiers_and_disabled(@tier1).should == [@id1,@id2]
      @id1.objective_definition.toggle!(:exempt_tier)
      #category
      @id1.intervention_cluster.toggle!(:exempt_tier)
      InterventionDefinition.restrict_tiers_and_disabled(@tier1).should == [@id1,@id2]
      @id1.intervention_cluster.intervention_definitions.restrict_tiers_and_disabled(@tier1).should == [@id1,@id2]
      @id1.intervention_cluster.toggle!(:exempt_tier)
      #first itnervention
      @id1.toggle!(:exempt_tier)
      InterventionDefinition.restrict_tiers_and_disabled(@tier1).should == [@id1]
      @id1.intervention_cluster.intervention_definitions.restrict_tiers_and_disabled(@tier1).should == [@id1]
      @id1.toggle!(:exempt_tier)
      #second intervention
      @id2.toggle!(:exempt_tier)
      InterventionDefinition.restrict_tiers_and_disabled(@tier1).should == [@id1,@id2]
      @id1.intervention_cluster.intervention_definitions.restrict_tiers_and_disabled(@tier1).should == [@id1,@id2]



    end






  end


    
  


end
