shared_context  "schools_requiring" do
  before(:each) do
    controller.should_receive(:require_current_school).any_number_of_times.and_return(true)
  end
end

shared_context "authenticated" do
  before(:each) do
    controller.should_receive(:authenticate).any_number_of_times.and_return(true)
  end
end

shared_context "authorized" do
  before(:each) do
    controller.should_receive(:authorize).any_number_of_times.and_return(true)
  end

  it 'should have all actions in action_groups (read or write for now.)' do
    controller.class.public_instance_methods(false).each do |public_action|
      controller.stub!(:action_name => public_action.to_s)
      flunk public_action.to_s if controller.send(:action_group_for_current_action).blank?
    end
  end
end

shared_examples_for "an authenticated controller" do
  it 'should have an authenticate before_filter' do
    before_filters(controller).should include(:authenticate)
  end
end

shared_examples_for "an authorized controller" do
  it_should_behave_like "an authenticated controller"
  it 'should have an authorize before_filter' do
    before_filters(controller).should include(:authorize)
  end
end

shared_examples_for "a schools_requiring controller" do
  it 'should have an require_current_school  before_filter' do
    before_filters(controller).should include(:require_current_school)
  end
end

def before_filters(controller)
 controller._process_action_callbacks.select{|k| k.kind == :before}.collect(&:filter)
end
