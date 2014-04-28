require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe District::LogsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  before do
    controller.stub_association!(:current_district,:logs=>DistrictLog)
  end

  describe 'index' do
    it 'should expose logs as @logs' do
      DistrictLog.should_receive(:for_display).and_return([1,2,3])
      get :index
      assigns(:logs).should == [1,2,3]
    end
  end
end
