# == Schema Information
# Schema version: 20090212222347
#
# Table name: districts
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  abbrev            :string(255)
#  state_dpi_num     :integer
#  state_id          :integer
#  created_at        :datetime
#  updated_at        :datetime
#  admin             :boolean
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe District do

  it 'should be valid' do
    Factory.build(:district).should be_valid
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
