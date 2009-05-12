# == Schema Information
# Schema version: 20090428193630
#
# Table name: states
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#  admin      :boolean
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe State do
  it "should create a new instance given valid attributes" do
    Factory(:state)
  end

  it 'should display name when to_s is called' do
    s=Factory(:state)
    s.to_s.should == s.name
  end

  it 'should have an admin_district' do
    s=Factory(:state)
    s.admin_district.should == s.districts.find_by_admin(true)
  end

  describe 'destroy' do
    before do
      @s=Factory(:state)

    end
    
    it 'should destroy all districts and news items' do
      @s.news.create!(:text=>'fake news')
      olddistcount=District.count
      @s.news.count.should == 1
      @s.destroy
      @s.news.count.should == 0
      District.count.should == (olddistcount -1 )
    end

    it 'should fail if there are normal districts' do
      d=@s.districts.first
      d.admin=false
      d.save
      @s.destroy.should == false
      @s.errors[:base].should == "Have the state admin remove the districts first."

    end
    

    

  end
end
