require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'ConsultationFormBuilder' do

  before do
    helper = Object.new.extend ActionView::Helpers::FormHelper
    @object = mock_consultation_form
    @builder = ConsultationFormBuilder.new(:consultation_form, @object, self, {}, nil)
  end


  it 'should have other specs'


  describe 'assets' do
    it 'should show empty ul when there are no assets' do
      @object.should_receive(:assets).and_return([])
      @builder.assets.should == "<ul></ul>"
    end

    it 'should show assets in an li when there is one' do
      @object.should_receive(:assets).and_return([Asset.new(:url=>'http://www.salad.com',:name => 'Salad')])
      @builder.assets.should have_tag("ul") do
        with_tag "li" do
          with_tag 'a[href="http://www.salad.com"]' do
            with_tag "img"
          end
        end
      end
    end
  end
end
