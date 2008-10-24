require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
#require RAILS_ROOT+'/app/controllers/application'
describe ApplicationController do
  def flash
    @flash ||= {}
  end
  it 'should authenticate' do
    controller.should_receive(:current_user_id).and_return(true)
    controller.send(:authenticate).should == true
  end

  it 'should redirect if false' do
    controller.should_receive(:current_user_id).and_return false
    controller.should_receive(:root_url).and_return 'root_url'
    controller.should_receive(:redirect_to).with('root_url')
    controller.should_receive(:flash).and_return(flash)
    controller.send(:authenticate).should == false
    flash[:notice].should_not == nil
  end

end
