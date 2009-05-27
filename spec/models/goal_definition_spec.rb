# == Schema Information
# Schema version: 20090524185436
#
# Table name: goal_definitions
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  district_id :integer
#  position    :integer
#  disabled    :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#  copied_at   :datetime
#  copied_from :integer
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GoalDefinition do
  before do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :position => "1",
      :disabled => false
    }
  end

  describe 'deep_clone' do
    before do
      @goal = Factory(:goal_definition)
      @admin_district = @goal.district.admin_district
      @target_district = @goal.district
      @goal.district=@admin_district
      @goal.save!
    end
    
    describe 'new goal in admin not in target' do
      it 'should add a copy of @goal to target_district' do
        @target_district.goal_definitions.should be_empty
        @admin_district.goal_definitions.first.deep_clone(@target_district)
        goal_copy = @target_district.goal_definitions.find(:first)
        goal_copy.copied_from.should == @goal.id
        goal_copy.copied_at.should_not be_nil
        goal_copy.id.should_not == @goal.id
        goal_copy.description.should == @goal.description
        goal_copy.title.should == @goal.title
        goal_copy.reload
        goal_copy.updated_at.should == goal_copy.copied_at
        
        
      end

      it 'should clone objective_definitions' do
        pending
      end
      
    end

    describe 'goal in admin unchanged in target' do
      it 'should not change' do
        goal=@admin_district.goal_definitions.first.deep_clone(@target_district)
        goal2= @admin_district.goal_definitions.first.deep_clone(@target_district)
        goal.should == goal2
      end

      it 'should clone objective_definitions' do
        
        pending
      end
      
    end

    describe 'goal in admin deleted in target' do
      it 'should not change or be created' do
        pending
        goal=@admin_district.goal_definitions.first.deep_clone(@target_district)
        goal.destroy
        goal2= @admin_district.goal_definitions.first.deep_clone(@target_district)
        goal2.should_not == goal
      end

    end

    describe 'goal deleted in admin' do
      describe 'unchanged in target' do
      end

      describe 'changed in target' do
      end

      describe 'in use in target' do
      end

    end

    describe 'goal changed in admin' do
      describe 'unchanged in target' do
      end

      describe 'changed in target' do
      end

      describe 'deleted in target' do
      end
      

    end

    


    
    it 'should clone child objectives' do
      pending
      g1 = Factory(:goal_definition)
      ods = Factory(:objective_definition, :goal_definition => g1) 
      g2 = g1.deep_clone(-1)
      g2.objective_definitions.map(&:title).should == g1.objective_definitions.map(&:title)
    end
  end

  it "should create a new instance given valid attributes" do
    GoalDefinition.create!(@valid_attributes)
  end

  describe 'objective_definitions' do
    it 'should build_with_new_asset' do
      gd=Factory(:goal_definition)
      od1=gd.objective_definitions.build
      od1.assets.build

      od2=gd.objective_definitions.build_with_new_asset
      od2.attributes.should == od1.attributes
      od1.assets.size.should == od2.assets.size
      od2.assets.first.attributes.should == od2.assets.first.attributes
    end
  end
end
