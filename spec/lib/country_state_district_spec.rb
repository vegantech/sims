require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


include CountryStateDistrict
describe "Populate Country State and District dropdowns" do
  describe 'dropdowns method' do
    before do 
     self.should_receive(:subdomains)
     self.stub!(:params =>{})
    end
    it 'should return if logged in' do
      self.should_receive(:current_user_id).and_return(true)
      dropdowns
    end

    it 'should populate countries states and districts if there are more than one' do
      district=District.new
      current_district = District.new(:name => 'Please Select a District')
      District.should_receive(:normal).and_return([district,7,8])
      self.should_receive(:current_user_id).and_return(false)
      dropdowns
      @districts.should == [district,7,8]
      @current_district.attributes.should == current_district.attributes
    end




  end 
end

