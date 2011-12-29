require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
#require RAILS_ROOT+'/app/controllers/application'
describe ApplicationController do
  def flash
    @flash ||= {}
  end

  describe 'mock_request' do
  before do
    @req=mock_object(:subdomains=>[])
    controller.stub!(:request).and_return(@req)
    @req.stub!(:url=>"gopher://www.example.com/")
    @req.stub!(:domain=>"www.example.com")
    controller.stub!(:params).and_return(flash)
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
    controller.should_receive(:session).at_least(:once).and_return(flash)
    controller.send(:authenticate).should == false
    flash[:notice].should_not == nil
    flash[:requested_url].should == "gopher://www.example.com/"
  end


  describe 'authorize' do
    
    it 'should return true if authorized' do
      controller.should_receive(:action_group_for_current_action).and_return("read")
      user=mock_user
      controller.should_receive(:current_user).and_return(user)
      user.should_receive(:authorized_for?).with('application','read').and_return(true)
      controller.send(:authorize).should == true

    end

    it 'should redirect and set a flash message if not authorized' do
      controller.should_receive(:action_group_for_current_action).and_return("read")
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

  describe 'require_school' do

      it 'should redirect and set a flash message if there is no school when html' do
        controller.should_receive(:current_school).and_return("")
        controller.should_receive(:schools_url).and_return("schools_url")
        controller.should_receive(:redirect_to).with('schools_url')
        controller.should_receive(:flash).and_return(flash)
        @req.should_receive(:xhr?).and_return(false)

        controller.send(:require_current_school).should == false
        flash[:notice].should == "Please reselect the school"

      end

      it 'should put up a message when xhr and there is no school' do

        controller.should_receive(:current_school).and_return("")
        @req.should_receive(:xhr?).and_return(true)
        page=mock_object
        page.should_receive(:[]).with(:flash_notice).and_return(page)
        page.should_receive(:insert).with("<br />Please reselect the school.")
        controller.should_receive(:render).and_yield(page)
        controller.send(:require_current_school).should == false

      end

      it 'should return true if there is a school' do
        controller.should_receive(:current_school).and_return("CURRENT")
        controller.send(:require_current_school).should == true
      end

  end

  describe 'action_group_for_current_action' do
    
    it 'should return write for create' do
      controller.stub!(:action_name=>"create")
      controller.send(:action_group_for_current_action).should == "write_access"
    end

    it 'should return read for index' do
      controller.stub!(:action_name=>"index")
      controller.send(:action_group_for_current_action).should == "read_access"
    end
      
      
    it 'should return nil for search' do
      controller.stub!(:action_name=>"kesds3search")
      controller.send(:action_group_for_current_action).should be_nil
    end

  end

  it 'has selected_student session helkpers' do
    controller.stub!(:session=>{:selected_students=>[1,2,3]})
    controller.send(:selected_students_ids).should == [1,2,3]
    controller.send('multiple_selected_students?').should == true
    
    controller.stub!(:session=>{:selected_students=>[1]})
    controller.send('multiple_selected_students?').should == false
  end

  describe 'subdomains' do
    it 'example.com' do
      controller.send('subdomains')
    end

    it 'simspilot.example.com' do
      controller.send('subdomains')

    end


    it 'sims.example.com' do
      controller.stub!(:current_subdomian => nil)
      controller.stub!(:params).and_return(flash)
      controller.send('subdomains')
    end

    describe '' do
      before do
        controller.stub!(:current_subdomian => 'test')
        controller.stub!(:params).and_return(flash)
        District.should_receive(:find_by_abbrev).with('test').and_return(@d=mock_district)
      end
      
      it 'example.com with explicit params in the url' do
        flash[:district_abbrev]='test'
        controller.send('subdomains')
      
      
      end
      it 'test.sims.example.com same district' do
        pending 'need to test ENABLE SUBDOMAINS'
        controller.send('subdomains')
        controller.instance_variable_get('@current_district').should == @d
      end

      it 'test.sims.example.com different district' do
        pending 'need to test ENABLE SUBDOMAINS'
        controller.instance_variable_set('@current_district','fake')
        controller.should_receive(:redirect_to)
        controller.should_receive(:logout_url)
        controller.send('subdomains')
      end

      it 'test-state.sims.example.com' do
        pending 'need to test ENABLE SUBDOMAINS'
        State.find_by_abbrev('wi') #from before above
        controller.stub_association!(:request,:subdomains=>['test-state','sims'], :domain=>"example.com")
        State.should_receive(:find_by_abbrev).with('state').and_return(mock_state(:districts=>District))
        controller.send('subdomains')
      end

      it 'test-wi-country' do 
        pending 'need to test ENABLE SUBDOMAINS'
        Country.find_by_abbrev('us') #from before above
        
        controller.stub_association!(:request,:subdomains=>['test-wi-country','sims'], :domain=>"example.com")
        Country.should_receive(:find_by_abbrev).with('country').and_return(mock_state(:states=>State))
        controller.send('subdomains')

      end
      
    end

  end
 
  end

    # Rails 2.3 and above 
  it 'should not throw an exception on OPTIONS request (from ms office protocol discovery)' do
    process '/any/goofy/path', nil, nil, nil, 'OPTIONS'
    response.should be_success
  end 

  describe 'check_student' do
    it 'should have specs'


  end




end

