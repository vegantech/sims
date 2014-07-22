shared_context  "schools_requiring" do
  before(:each) do
    controller.should_receive(:require_current_school).any_number_of_times.and_return(true)
  end
end

shared_context "authenticated" do
  before(:each) do
    controller.stub!(check_domain: true)
    controller.should_receive(:authenticate_user!).any_number_of_times.and_return(true)
    controller.stub!(current_user: mock_user(:district => District.new, "authorized_for?" => true, :roles => ["regular_user"]))
  end
end

shared_context "authorized" do
  before(:each) do
    controller.should_receive(:authorize).any_number_of_times.and_return(true)
  end
end

shared_examples_for "an authenticated controller" do
  it 'should have an authenticate before_filter' do
    before_filters(controller).should include(:authenticate_user!)
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
