require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuilderHelper do
  include BuilderHelper


  describe 'add_user_school_assignment_link' do
    it 'should call append_asset_link on page' do
      template=mock("template")
      self.should_receive(:link_to_function).with('fake_name').and_yield(template)
      UserSchoolAssignment.should_receive(:new).and_return(m=mock_user_school_assignment)
      template.should_receive(:insert_html).with(:bottom, :user_school_assignments, :partial=>"user_school_assignment", :object=>m).and_return("blah")
      add_user_school_assignment_link('fake_name').should ==  'blah'
    end
    
  end


end

