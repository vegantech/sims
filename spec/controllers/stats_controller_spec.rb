require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StatsController do

  describe "responding to GET index" do
    it 'should work without error' do
      get :index
      response.should be_success
    end

    it 'should work without error when excluding a district' do
      get :index, :without => District.last.id
      response.should be_success

    end
    it 'should have other specs'
  end
end
