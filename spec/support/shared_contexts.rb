describe "a schools_requiring controller", :shared => true do
  before(:each) do
    controller.should_receive(:require_current_school).any_number_of_times.and_return(true)
    controller.class.before_filters.should include(:require_current_school)
  end
end

describe "an authenticated controller", :shared => true do
  before(:each) do
    controller.should_receive(:authenticate).any_number_of_times.and_return(true)
    controller.class.before_filters.should include(:authenticate)
  end
end

describe "an authorized controller", :shared => true do
  before(:each) do
    controller.should_receive(:authorize).any_number_of_times.and_return(true)
    controller.class.before_filters.should include(:authorize)
  end

  it 'should have all actions in action_groups (read or write for now.)' do
    controller.class.public_instance_methods(false).each do |public_action|
      controller.stub!(:action_name => public_action.to_s)
      # controller.send(:action_group_for_current_action).should_not be_nil
      flunk public_action.to_s if controller.send(:action_group_for_current_action).blank?
    end
  end
end


