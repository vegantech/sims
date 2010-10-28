# == Schema Information
# Schema version: 20101027022939
#
# Table name: principal_overrides
#
#  id                 :integer(4)      not null, primary key
#  teacher_id         :integer(4)
#  student_id         :integer(4)
#  principal_id       :integer(4)
#  status             :integer(4)      default(0)
#  start_tier_id      :integer(4)
#  end_tier_id        :integer(4)
#  principal_response :string(1024)
#  teacher_request    :string(1024)
#  created_at         :datetime
#  updated_at         :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PrincipalOverride do
  before(:each) do
    @valid_attributes = {
      :status => 0,
      :teacher_request => "value for fufillment_reason",
      :student=>mock_student(:max_tier=>Tier.new(:title=>"TIER 1"), :principals=>[User.new], :fullname => "Test Student", :district => Factory(:district)),
      :teacher=>User.new
    }
  end

  it "should create a new instance given valid attributes" do
    PrincipalOverride.create!(@valid_attributes)
  end

  describe 'max_tier' do
    it 'should return nil when there are no checklists' do
      PrincipalOverride.max_tier.should be_nil
    end
    
    it 'should return the tier of the highest promoted Principal Override' do
      po1= PrincipalOverride.create!(@valid_attributes)
      PrincipalOverride.approved.should ==[]

      po1.status=PrincipalOverride::APPROVED_NOT_SEEN
      po1.end_tier=Tier.new(:title=>"Tier 2")
      po1.principal_response='test response'
      po1.action="accept"
      po1.save!

      PrincipalOverride.approved.should ==[po1]

      PrincipalOverride.max_tier.should == po1.end_tier
      

    end
  end

end
