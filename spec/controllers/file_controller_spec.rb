require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FileController do
 it_should_behave_like "an authenticated controller"


  describe "GET 'download'" do
    it "should call sendfile with filename" do
      controller.should_receive(:send_file).with(File.join(RAILS_ROOT,"file","shawn"), :x_sendfile=>true)
      get 'download', :filename=>'shawn'
      response.should be_success
    end

    it 'should not show the README in rails root' do
      get 'download', :filename =>'../README'
    end

  end

end
