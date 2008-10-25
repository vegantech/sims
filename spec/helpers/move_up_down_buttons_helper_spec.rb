require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe MoveUpDownButtonsHelper do
include MoveUpDownButtonsHelper  
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(MoveUpDownButtonsHelper)
  end

  it 'should make a button up and down when move_up_down_buttons is called' do
    self.should_receive(:move_button).with(:up,'').and_return("up")
    self.should_receive(:move_button).with(:down,'').and_return("up")
    move_up_down_buttons('').should have_tag("br")

  end

  it 'should generate a move button' do 
    self.should_receive(:move_path).with('',:up).and_return("UP MOVE PATH")
    button_html = move_button(:up, '').should have_tag("form[action=?]","UP MOVE PATH") do
      with_tag("input[type=?][src*=?]","image","arrow-up.gif")
      with_tag("input[type=?][value=?]","hidden","put")
    end
 end


end
