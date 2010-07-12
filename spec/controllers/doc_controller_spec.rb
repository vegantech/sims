require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))
describe DocController do
  describe 'index' do
    it 'should be successful' do
      get :index
      response.should be_success
    end
  end

  describe 'district_upload' do
    it 'should be successful' do
      get :district_upload
      response.should be_success
    end


  end


end

