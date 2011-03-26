require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuilderHelper do
  include BuilderHelper

  describe 'exempt_tiers_box' do
    it 'should return an empty string if the district does not lock tiers' do
      d=District.new(:lock_tier => false)
      self.should_receive(:current_district).and_return(d)
      form_for(GoalDefinition.new, :url=>intervention_builder_goals_path) { |form|
        exempt_tiers_box(form, '').should == ''
      }

    end

    it 'should display the checkbox with the help popup if the district does lock tiers' do
      d=District.new(:lock_tier => true)
      self.should_receive(:current_district).and_return(d)
      self.should_receive(:help_popup).with('Interventions under this goal are available to all.').and_return('this is the help popup with goal available')
      form_for(GoalDefinition.new, :url=>intervention_builder_goals_path) { |form|
        exempt_tiers_box(form, 'Interventions under this goal are available to all.').should == "<p><div class='fake_label'><input name=\"goal_definition[exempt_tier]\" type=\"hidden\" value=\"0\" /><input id=\"goal_definition_exempt_tier\" name=\"goal_definition[exempt_tier]\" type=\"checkbox\" value=\"1\" /></div><label class=\"checkbox_label_span\" for=\"goal_definition_exempt_tier\">Available to all tiers</label>this is the help popup with goal available</p>"
      }
    end

  end


  describe 'add_user_school_assignment_link' do
    it 'should call append_asset_link on page when @users is set' do
      template=mock("template")
      self.should_receive(:link_to_function).with('fake_name').and_yield(template)
      UserSchoolAssignment.should_receive(:new).and_return(m=mock_user_school_assignment)
      template.should_receive(:insert_html).with(:bottom, :user_school_assignments, :partial=>"user_school_assignment", :object=>m).and_return("blah")
      self.instance_variable_set('@users', 'e') 
      add_user_school_assignment_link('fake_name').should ==  'blah'
    end

    it 'should call append_asset_link on page when @schools is set ' do
      template=mock("template")
      self.should_receive(:link_to_function).with('fake_name').and_yield(template)
      UserSchoolAssignment.should_receive(:new).and_return(m=mock_user_school_assignment)
      template.should_receive(:insert_html).with(:bottom, :user_school_assignments, :partial=>"user_school_assignment", :object=>m).and_return("blah")
      self.instance_variable_set('@schools', 'e') 
      add_user_school_assignment_link('fake_name').should ==  'blah'
    end

    it 'should call not append_asset_link when @users and @schools are unset' do
      template=mock("template")
      self.should_not_receive(:link_to_function).with('fake_name').and_yield(template)
      UserSchoolAssignment.should_not_receive(:new).and_return(m=mock_user_school_assignment)
      template.should_not_receive(:insert_html).with(:bottom, :user_school_assignments, :partial=>"user_school_assignment", :object=>m).and_return("blah")
      add_user_school_assignment_link('fake_name').should ==  "<p>There are more than 100 users in the district; please assign new  school assignments through the add/remove users interface.</p>" 
      'blah'
    end
 
 
  end


end

