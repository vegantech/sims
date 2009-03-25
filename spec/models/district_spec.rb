# == Schema Information
# Schema version: 20090325214721
#
# Table name: districts
#
#  id                    :integer         not null, primary key
#  name                  :string(255)
#  abbrev                :string(255)
#  state_dpi_num         :integer
#  state_id              :integer
#  created_at            :datetime
#  updated_at            :datetime
#  admin                 :boolean
#  logo_file_name        :string(255)
#  logo_content_type     :string(255)
#  logo_file_size        :integer
#  logo_updated_at       :datetime
#  marked_state_goal_ids :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe District do

  before(:all) do
    @local_district = Factory(:district, :name=>"GD_TEST", :abbrev=>"CKAZZ2")
    @state_district = @local_district.state.districts.admin.first
  end
  it 'should be valid' do
    Factory.build(:district).should be_valid
  end

  describe 'goal_definitions_for_state' do
    before(:all) do
      @marked_sd_gd = Factory(:goal_definition, :district => @state_district)
      @local_district.marked_state_goal_ids= @marked_sd_gd.id.to_s
      @local_district.save
      @unmarked_sd_gd = Factory(:goal_definition, :district => @state_district)
      @ld_gd = Factory(:goal_definition, :district => @local_district)
    end

    it 'should find all with our district id' do
      @local_district.goal_definitions_with_state.should include(@ld_gd)
    end

    it 'should include only marked goal definitions from state district' do
      @state_district.goal_definitions.should include(@marked_sd_gd)
      @local_district.goal_definitions_with_state.should include(@marked_sd_gd)
      @local_district.goal_definitions_with_state.should_not include(@unmarked_sd_gd)
    end

  end

  describe 'active_checklist_definition method' do
    before(:all) do
      @sd_cd = Factory(:checklist_definition, :district => @state_district)
      @ld_cd = Factory(:checklist_definition, :district => @local_district)
    end

    describe 'with an active state definition' do
      before do
        @sd_cd.update_attribute(:active,true)
      end
    
      describe 'with active district definition' do
        it "should return district's active definition" do
          @ld_cd.update_attribute(:active,true)
          @local_district.active_checklist_definition.should == @ld_cd
        end
      end
      describe 'without active district definition' do
        it "should return state's active definition" do
          @ld_cd.update_attribute(:active,false)
          @local_district.active_checklist_definition.should == @sd_cd
        end
      end
    end
    describe 'without an active state definition' do
      before do
        @sd_cd.update_attribute(:active,false)
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
          @local_district.active_checklist_definition.should be_new_record
        end
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


end
