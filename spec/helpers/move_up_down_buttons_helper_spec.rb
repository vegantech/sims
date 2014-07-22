require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe MoveUpDownButtonsHelper do
  #Delete this example and add some real ones or delete this file
    it 'should make a button up and down when move_up_down_buttons is called' do
    helper.should_receive(:move_button).with(:up,'').and_return("up")
    helper.should_receive(:move_button).with(:down,'').and_return("up")
    helper.move_up_down_buttons('').should have_tag("br")

  end

  it 'should generate a move button' do
    helper.should_receive(:move_path).with('',:up).and_return("UP MOVE PATH")
    button_html =helper.move_button(:up, '').should have_form("UP MOVE PATH", 'post') do
      with_tag("input", :with => {:type => :image, 'src*' => "arrow-up.gif"})
      with_tag("input", :with => {:type => :hidden, 'value' => "put"})
    end
 end

end
