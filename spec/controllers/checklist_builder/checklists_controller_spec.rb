require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ChecklistBuilder::ChecklistsController do
  it_should_behave_like "an authorized controller"
  include_context "authorized"
  include_context "authenticated"

  before do
    controller.stub!(:current_user => mock_user(:district => District.new, "authorized_for?" => true, :roles => ["regular_user"],:principal_override_requests=> [], "principal?" => false))
  end

  render_views
  #Delete this example and add some real ones
  it "should use ChecklistBuilder::ChecklistsController" do
    controller.should be_an_instance_of(ChecklistBuilder::ChecklistsController)
  end

  it 'should get index' do
    d=Factory(:district)
    admin = District.admin.first || Factory(:district,:admin=>true)
    controller.stub!(:current_district).and_return(d)
    a=ChecklistDefinition.create!(:text=>'text', :directions=>'directions',:district=>d)
    get :index
    assigns(:checklist_definitions).should == [a]
    response.should be_success
  end

  it 'should get preview' do
    d=Factory(:district)
    controller.stub!(:current_district).and_return(d)
    a=ChecklistDefinition.create!(:text=>'text', :directions=>'directions',:district=>d)

    get :preview, :id=>a.id.to_s
    assigns(:checklist_definition).should == a
    assigns(:checklist).skip_cache.should be_true
    assigns(:checklist).checklist_definition.should == a
    response.should be_success

  end

  it 'should get new' do
    d=Factory(:district)
    controller.stub!(:current_district).and_return(d)
    get :new
    response.should be_success
  end

  it 'should show checklist definition' do
    d=Factory(:district)
    controller.stub!(:current_district).and_return(d)
    a=ChecklistDefinition.create!(:text=>'text', :directions=>'directions',:district=>d)
    get :show, :id=>a.id
    response.should be_success
    assigns(:checklist_definition).should ==(a)
  end

  it 'should get edit' do
    d=Factory(:district)
    controller.stub!(:current_district).and_return(d)
    a=ChecklistDefinition.create!(:text=>'text', :directions=>'directions',:district=>d)
    get :edit, :id=>a.id
    response.should be_success
    assigns(:checklist_definition).should ==(a)
  end

  it 'should create_checklist_definition on post create' do
    pending
    old_count = ChecklistDefinition.count
    post :create,
         :checklist_definition => { :directions => "Fill all of these out please" }
    response.should redirect_to(checklist_builder_checklist_path(assigns(:checklist_definition)))
    ChecklistDefinition.count should ==  old_count+1
  end

  describe 'new_from_this' do

    it 'should set the flash and not save if the checklist is not available to the current district' do
      d=Factory(:district)
      a=ChecklistDefinition.create!(:text=>'text', :directions=>'directions')
      a.update_attribute(:district_id, nil)
      controller.stub!(:current_district).and_return(d)
      post :new_from_this, :id=>a.id
      assigns(:new_checklist_definition).should be_nil
      flash[:notice].should == "Checklist Definition could not be copied"
      response.should redirect_to(checklist_builder_checklists_url)
    end

    it 'should set the flash and save if the old checklist belongs to the district' do
      d=Factory(:district)
      a=d.checklist_definitions.create!(:text=>'text', :directions=>'directions')
      controller.stub!(:current_district).and_return(d)
      post :new_from_this, :id=>a.id
      assigns(:new_checklist_definition).new_record?.should be_false
      flash[:notice].should == "Checklist Definition was successfully copied"
      response.should redirect_to(checklist_builder_checklists_url)

    end

    it 'should set the flashand save if the old checklist belongs to the state_district' do
      d=Factory(:district)
      admin_district = District.admin.first || Factory(:district, :admin => true)
      a=ChecklistDefinition.create!(:text=>'text', :directions=>'directions')
      a.update_attribute(:district_id,d.admin_district.id)
      controller.stub!(:current_district).and_return(d)
      post :new_from_this, :id=>a.id
      assigns(:new_checklist_definition).new_record?.should be_false
      flash[:notice].should == "Checklist Definition was successfully copied"
      response.should redirect_to(checklist_builder_checklists_url)
    end
  end

  describe 'destroy' do
    it 'should destroy the selected checklist' do
      d=Factory(:district)
      a=d.checklist_definitions.create!(:text=>'text', :directions=>'directions')
      controller.stub!(:current_district).and_return(d)
      proc{delete :destroy, :id => a.id}.should change(ChecklistDefinition, :count).by(-1)

    end

  end

end

=begin
 
 
  def test_should_update_checklist_definition
    put :update, :id => 2, 
                 :checklist_definition => { :text => "Something new" }
    assert_redirected_to checklist_definition_path(assigns(:checklist_definition))
    assert_not_equal @checklist_definition_two.text, ChecklistDefinition.find(2).text
  end
  
  def test_should_destroy_checklist_definition
    old_count = ChecklistDefinition.count
    delete :destroy, :id => 1
    assert_equal old_count-1, ChecklistDefinition.count
    
    assert_redirected_to checklist_definitions_path
  end
  
  def test_should_handle_errors_when_creating_checklist_definition
    old_count = ChecklistDefinition.count
    post :create, :checklist_definition => { :directions => nil }
    assert_equal old_count, ChecklistDefinition.count
    
    assert_response :success
    assert_template 'new'
  end

  def test_should_handle_errors_when_updating_checklist_definition
    put :update ,:id => 2,
                 :checklist_definition => { :directions => nil}
    assert_response :success
    assert_template 'edit'
  end
  
=end
