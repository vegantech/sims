require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe SchoolAdminController do
  def flash
    @flash ||= {}
  end

  def mock_object(*args)
    @mo ||= Object.new
    @mo.stub!(*args||{})
  end

  describe 'mock_request' do
    before do
      @req=mock(:subdomain=>'')
      controller.stub!(:request).and_return(@req)
      @req.stub!(:url=>"gopher://www.example.com/")
      @req.stub!(:domain=>"www.example.com")
      controller.stub!(:params).and_return(flash)
    end

    describe 'authorize' do
      let(:user) {mock_user}
      let(:school) {mock_school}
      before do
        controller.should_receive(:current_user).and_return(user)
        controller.should_receive(:current_school).and_return(school)
      end

      it 'should return true if authorized' do
        user.should_receive(:admin_of_school?).with(school).and_return(true)
        controller.send(:authorize).should == true
      end

      it 'should redirect and set a flash message if not authorized' do
        user.should_receive(:admin_of_school?).with(school).and_return(false)
        controller.should_receive(:not_authorized_url).and_return 'root_url'
        controller.should_receive(:redirect_to).with('root_url')
        controller.should_receive(:flash).and_return(flash)
        controller.send(:authorize).should == false
        flash[:notice].should == "You are not authorized to access that page"
      end
    end
  end
end

