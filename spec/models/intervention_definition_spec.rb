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
      iid=FactoryGirl.build(:intervention_definition, :district_quicklist=>'1')
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
      @ic1 = @id1.intervention_cluster
      @id2=Factory(:intervention_definition, :intervention_cluster => @ic1)
      @id3=Factory(:intervention_definition, :intervention_cluster => @ic1, :disabled=>true)
      @district = @id1.district
      @tier1=@district.tiers.create!(:title => 'tier 1')
      @tier2=@district.tiers.create!(:title => 'tier 2')
      @id1.update_attribute(:tier_id, @tier1.id)
      @id2.update_attribute(:tier_id, @tier2.id)
    end

    it 'should show all when there are no restrictions' do
      @district.update_attribute(:lock_tier, false)
      InterventionDefinition.restrict_tiers_and_disabled(@tier1,@district).should == [@id1,@id2]
      @ic1.intervention_definitions.restrict_tiers_and_disabled(@tier1,@district).should == [@id1,@id2]
    end

    describe 'with district locking tiers do' do
      before do
        @district.update_attribute(:lock_tier, true)
      end
      it 'should restrict when the district lock tiers' do
        InterventionDefinition.restrict_tiers_and_disabled(@tier1,@district).should == [@id1]
        @ic1.intervention_definitions.restrict_tiers_and_disabled(@tier1,@district).should == [@id1]
      end

      it 'should  allow the intervention definitions when the goal definition is exempted' do
        @id1.goal_definition.update_attribute(:exempt_tier,true)
        InterventionDefinition.restrict_tiers_and_disabled(@tier1,@district).should == [@id1,@id2]
        @ic1.intervention_definitions.restrict_tiers_and_disabled(@tier1,@district).should == [@id1,@id2]
      end

      it 'should allow the intervention definitions when the objective definition is exempted' do
        @id1.objective_definition.update_attribute(:exempt_tier,true)
        InterventionDefinition.restrict_tiers_and_disabled(@tier1,@district).should == [@id1,@id2]
        @ic1.intervention_definitions.restrict_tiers_and_disabled(@tier1,@district).should == [@id1,@id2]
      end

      it 'should allow the intervention definitions when the category is exempted' do
        @ic1.update_attribute(:exempt_tier,true)
        InterventionDefinition.restrict_tiers_and_disabled(@tier1,@district).should == [@id1,@id2]
        @ic1.intervention_definitions.restrict_tiers_and_disabled(@tier1,@district).should == [@id1,@id2]
      end



      it 'should allow when the district lock tiers but individual exemptions are in place' do
        @id1.update_attribute(:exempt_tier,true)
        InterventionDefinition.restrict_tiers_and_disabled(@tier1,@district).should == [@id1]
        @ic1.intervention_definitions.restrict_tiers_and_disabled(@tier1,@district).should == [@id1]
        @id1.update_attribute(:exempt_tier,false)
        #second intervention
        @id2.update_attribute(:exempt_tier,true)
        InterventionDefinition.restrict_tiers_and_disabled(@tier1,@district).should == [@id1,@id2]
        @ic1.reload.intervention_definitions.restrict_tiers_and_disabled(@tier1,@district).should == [@id1,@id2]
      end
    end
  end
  describe 'for_dropdown' do
    before :all do
      InterventionDefinition.delete_all
      @cucumber_user = Factory(:user)
      @cucumber_district = @cucumber_user.district
      @cucumber_school = Factory(:school, :district => @cucumber_district)
      gd=Factory(:goal_definition, :district => @cucumber_district)
      od=Factory(:objective_definition, :goal_definition => gd)
      @category = Factory(:intervention_cluster, :objective_definition => od)
      @suss = Factory(:intervention_definition, :intervention_cluster => @category, :title => "same_user_same_school",
              :user_id => @cucumber_user.id, :school_id => @cucumber_school.id, :custom => true)
      @suds = Factory(:intervention_definition, :intervention_cluster => @category, :title => "same_user_different_school",
              :user_id => @cucumber_user.id, :school_id => -1, :custom => true)
      @duss = Factory(:intervention_definition, :intervention_cluster => @category, :title => "different_user_same_school",
              :user_id => -1, :school_id => @cucumber_school.id, :custom => true)
      @duds = Factory(:intervention_definition, :intervention_cluster => @category, :title => "different_user_different_school",
              :user_id => -1, :school_id => -1, :custom => true)
      @dis = Factory(:intervention_definition, :intervention_cluster => @category, :title => "disabled",
              :disabled => true)
      @sys = Factory(:intervention_definition, :intervention_cluster => @category, :title => "system")
    end

    it 'district custom interventions disabled' do
      @cucumber_district.custom_interventions = "disabled"
      InterventionDefinition.for_dropdown(nil,@cucumber_district, @cucumber_school.id, @cucumber_user).should =~
        [@sys, @suss, @suds]
    end

    it 'district custom interventions enabled' do
      @cucumber_district.custom_interventions = ""
      InterventionDefinition.for_dropdown(nil,@cucumber_district, @cucumber_school.id, @cucumber_user).should =~
        [@sys, @suss, @suds, @duss]
    end

    it 'district custom interventions content_admins' do
      @cucumber_district.custom_interventions = "content_admins"
      InterventionDefinition.for_dropdown(nil,@cucumber_district, @cucumber_school.id, @cucumber_user).should =~
        [@sys, @suss, @suds, @duss]
    end

    it 'district custom interventions only_author' do
      @cucumber_district.custom_interventions = "only_author"
      InterventionDefinition.for_dropdown(nil,@cucumber_district, @cucumber_school.id, @cucumber_user).should =~
        [@sys, @suss, @suds]
    end

    it 'district custom interventions only_author' do
      @cucumber_district.custom_interventions = "one_off"
      InterventionDefinition.for_dropdown(nil,@cucumber_district, @cucumber_school.id, @cucumber_user).should =~
        [@sys]
    end
  end
end
