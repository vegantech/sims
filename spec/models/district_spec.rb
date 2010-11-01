# == Schema Information
# Schema version: 20101101011500
#
# Table name: districts
#
#  id                    :integer(4)      not null, primary key
#  name                  :string(255)
#  abbrev                :string(255)
#  state_dpi_num         :integer(4)
#  created_at            :datetime
#  updated_at            :datetime
#  admin                 :boolean(1)
#  logo_file_name        :string(255)
#  logo_content_type     :string(255)
#  logo_file_size        :integer(4)
#  logo_updated_at       :datetime
#  marked_state_goal_ids :string(255)
#  key                   :string(255)     default("")
#  previous_key          :string(255)     default("")
#  lock_tier             :boolean(1)
#  restrict_free_lunch   :boolean(1)      default(TRUE)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe District do

  before(:all) do
    @local_district = District.find_by_name("GD_TEST") || Factory(:district, :name=>"GD_TEST", :abbrev=>"CKAZZ2")
    @district2 = District.find_by_name("district_2") || Factory(:district, :name=>"district_2", :abbrev=>"DIST2")
    @state_district = District.admin.first ||  Factory(:district, :admin=>true)
  end
  it 'should be valid' do
    Factory.build(:district).should be_valid
  end

  describe 'active_checklist_definition method' do
    before(:all) do
      ChecklistDefinition.delete_all
      @ld_cd = Factory(:checklist_definition, :district => @local_district)
    end

    describe 'with active district definition' do
      it "should return district's active definition" do
        @ld_cd.update_attribute(:active,true)
        @local_district.active_checklist_definition.should == @ld_cd
      end
    end
    describe 'without active district definition' do
      it 'should return nil' do
        @ld_cd.update_attribute(:active,false)
        @local_district.active_checklist_definition.should be_nil
      end
    end
  end

  it "grades should return GRADES constant" do
    District.new.grades.should == District::GRADES
  end

  it 'should find intervention defintiion by id' do
    district=District.new
    district.should_receive(:id).and_return(5)
    InterventionDefinition.should_receive(:find).with(3,:include=>{:intervention_cluster=>{:objective_definition=>:goal_definition}},
                                                       :conditions=>{'goal_definitions.district_id'=>5}).and_return(true)
    district.find_intervention_definition_by_id(3).should == true
  end

  it 'should search intervention_by' do
    district=District.new
    district.should_receive(:objective_definitions).and_return([])
    district.search_intervention_by.should == []
  end

  describe "available_roles" do
    it 'should merge system and district roles' do
      district_roles=[1,2,4]
      system_roles = [2,3,5]
      district=District.new

      district.should_receive(:roles).and_return(district_roles)
      System.should_receive(:roles).and_return(system_roles)
      district.available_roles.should == [1,2,4,3,5]
    end

  end

 describe 'admin district' do
    it 'should return the state admin district for a leaf (normal) district' do
      @local_district.admin_district.should == @state_district
    end
  end

  describe 'key validation' do
    it 'should fail validation if there is a previous key and the key is changed' do
      @local_district.previous_key = 'different'
      @local_district.key = nil
      @local_district.save!

      @local_district.key = 'dog'
      @local_district.should_not be_valid

      @local_district.previous_key = ''
      @local_district.should be_valid

      @local_district.save
      @local_district.key= 'cat'
      @local_district.save

      @local_district.previous_key.should == 'dog'

      
      
      

      
      

    end

  end
end
