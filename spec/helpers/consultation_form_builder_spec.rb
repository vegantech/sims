require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe 'ConsultationFormBuilder', :type => :helper do

  before do
    #elper = Object.new.extend ActionView::Helpers::FormHelper
    @object = mock_consultation_form
    @template =  helper
    @builder = ConsultationFormBuilder.new(:consultation_form, @object, self, {}, nil)
    @builder.instance_variable_set("@template", helper)
  end


  it 'should have other specs'


  describe 'assets' do
    it 'should show empty ul when there are no assets' do
      @object.should_receive(:assets).and_return([])
      @builder.assets.should == "<ul></ul>"
    end

    it 'should show assets in an li when there is one' do
      @object.should_receive(:assets).and_return([Asset.new(:url=>'http://www.salad.com',:name => 'Salad')])
      @builder.assets.should have_selector("ul li a",:text => "Salad", :href => 'http://www.salad.com')
    end
  end
end
