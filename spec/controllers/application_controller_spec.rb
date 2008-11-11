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


  describe 'authorize' do
    
    it 'should return true if authorized' do
      controller.should_receive(:action_group_for).and_return("read")
      user=mock_user
      controller.should_receive(:current_user).and_return(user)
      user.should_receive(:authorized_for?).with('application','read').and_return(true)
      controller.send(:authorize).should == true

    end

    it 'should redirect and set a flash message if not authorized' do
      controller.should_receive(:action_group_for).and_return("read")
      user=mock_user
      controller.should_receive(:current_user).and_return(user)
      user.should_receive(:authorized_for?).with('application','read').and_return(false)
      controller.should_receive(:root_url).and_return 'root_url'
      controller.should_receive(:redirect_to).with('root_url')
      controller.should_receive(:flash).and_return(flash)
      controller.send(:authorize).should == false
      flash[:notice].should == "You are not authorized to access that page"
      

    end
  end

  describe 'action_group_for' do
    it 'should return read or write for the default restful actions' do
      pending
      #action_group_for(action_name)
    end
    
    
  end




end
