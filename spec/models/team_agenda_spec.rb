require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TeamAgenda do
  before(:each) do
    @valid_attributes = {
      :team => ,
      :date => Date.today,
      :notes => "value for notes"
    }
  end

  it "should create a new instance given valid attributes" do
    TeamAgenda.create!(@valid_attributes)
  end
end
