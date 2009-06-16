require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuilderHelper do
  include BuilderHelper


  describe 'add_user_school_assignment_link' do
    it 'should call append_asset_link on page when @users is set' do
      template=mock("template")
      self.should_receive(:link_to_function).with('fake_name').and_yield(template)
      UserSchoolAssignment.should_receive(:new).and_return(m=mock_user_school_assignment)
      template.should_receive(:insert_html).with(:bottom, :user_school_assignments, :partial=>"user_school_assignment", :object=>m).and_return("blah")
      self.instance_variable_set('@users', 'e') 
      add_user_school_assignment_link('fake_name').should ==  'blah'
    end

    it 'should call append_asset_link on page when @schools is set ' do
      template=mock("template")
      self.should_receive(:link_to_function).with('fake_name').and_yield(template)
      UserSchoolAssignment.should_receive(:new).and_return(m=mock_user_school_assignment)
      template.should_receive(:insert_html).with(:bottom, :user_school_assignments, :partial=>"user_school_assignment", :object=>m).and_return("blah")
      self.instance_variable_set('@schools', 'e') 
      add_user_school_assignment_link('fake_name').should ==  'blah'
    end

    it 'should call not append_asset_link when @users and @schools are unset' do
      template=mock("template")
      self.should_not_receive(:link_to_function).with('fake_name').and_yield(template)
      UserSchoolAssignment.should_not_receive(:new).and_return(m=mock_user_school_assignment)
      template.should_not_receive(:insert_html).with(:bottom, :user_school_assignments, :partial=>"user_school_assignment", :object=>m).and_return("blah")
      add_user_school_assignment_link('fake_name').should ==  "<p>There are more than 100 users in the district; please assign new  school assignments through the add/remove users interface.</p>" 
      'blah'
    end
 
 
  end


end

