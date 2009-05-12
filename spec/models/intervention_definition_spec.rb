# == Schema Information
# Schema version: 20090428193630
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
#  created_at              :datetime
#  updated_at              :datetime
#  deleted_at              :datetime
#  copied_at               :datetime
#  copied_from             :integer
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

    
    
  


end
