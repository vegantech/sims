require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuilderHelper do
  include BuilderHelper

  describe 'exempt_tiers_box' do
    it 'should return an empty string if the district does not lock tiers' do
      d=District.new(lock_tier: false)
      self.should_receive(:current_district).and_return(d)
      form_for(GoalDefinition.new, url: intervention_builder_goals_path) { |form|
        exempt_tiers_box(form, '').should == ''
      }

    end

    it 'should display the checkbox with the help popup if the district does lock tiers' do
      d=District.new(lock_tier: true)
      self.should_receive(:current_district).and_return(d)
      self.should_receive(:help_popup).with('Interventions under this goal are available to all.').and_return('this is the help popup with goal available')
      form_for(GoalDefinition.new, url: intervention_builder_goals_path) { |form|
        exempt_tiers_box(form, 'Interventions under this goal are available to all.').should == "<p><div class='fake_label'><input name=\"goal_definition[exempt_tier]\" type=\"hidden\" value=\"0\" /><input id=\"goal_definition_exempt_tier\" name=\"goal_definition[exempt_tier]\" type=\"checkbox\" value=\"1\" /></div><label class=\"checkbox_label_span\" for=\"goal_definition_exempt_tier\">Available to all tiers</label>this is the help popup with goal available</p>"
      }
    end

  end

end
