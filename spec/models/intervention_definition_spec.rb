# == Schema Information
# Schema version: 20081208201532
#
# Table name: intervention_definitions
#
#  id                      :integer         not null, primary key
#  title                   :string(255)
#  description             :text
#  custom                  :boolean
#  intervention_cluster_id :integer
#  tier_id                 :integer
#  time_length_id          :integer
#  time_length_num         :integer         default(1)
#  frequency_id            :integer
#  frequency_multiplier    :integer         default(1)
#  user_id                 :integer
#  school_id               :integer
#  disabled                :boolean
#  position                :integer
#  rec_mon_preface         :string(255)
#  created_at              :datetime
#  updated_at              :datetime
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
      k.district_quicklist.should_not == nil

      ql.destroy
      k.reload.district_quicklist.should == nil
    end

    it 'should assign itself to the quicklist if = "1"' do
      k=Factory(:intervention_definition)
      k.district_quicklist.should == nil
      k.district_quicklist = "1"
      k.save
      k.district.quicklist_items.first.intervention_definition.should == k
      k.district_quicklist.should_not == nil
    end

    it 'should remove itself from the quicklist if = false' do
      k=Factory(:intervention_definition)
      k.district_quicklist ="1"
      k.save
      k.district_quicklist ="0"
      k.save
      k.district_quicklist.should == nil
      k.district.quicklist_items.should == []
      k.reload
      k.district_quicklist =false
      k.district_quicklist.should == nil
    end
  end

    
    
  


end
