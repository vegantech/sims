require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


include CountryStateDistrict
describe "Populate Country State and District dropdowns" do
  describe 'dropdowns method' do
    before do 
     self.should_receive(:subdomains)
     self.stub!(:params =>{})
    end
    it 'should return if logged in' do
      Country.should_not_receive(:normal)
      self.should_receive(:current_user_id).and_return(true)
      dropdowns
    end

    it 'should populate countries states and districts if there are more than one' do
      country=Country.new
      state=State.new
      district=District.new
      current_district = District.new(:state=> state, :name => 'Please Select a District')
      country.stub_association!(:states,:normal=>[5,6,state])
      state.stub_association!(:districts, :normal=>[district,7,8], :build => current_district)
      Country.should_receive(:normal).and_return([country,2,3])
      self.should_receive(:current_user_id).and_return(false)
      dropdowns
      @countries.should == [country,2,3]
      @country.should == country
      @states.should == [5,6,state]
      @state.should == state
      @districts.should == [district,7,8]
      @current_district.should == current_district
    end




  end 
end

