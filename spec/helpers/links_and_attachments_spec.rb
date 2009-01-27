require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "LinksAndAttachmentsHelper", :type => :view do


  def fake_update_page(method,*args)
    update_page do |page|
      self.stub!(:page=>page)
      send(method, *args)
    end
  end


  describe 'add_asset_link' do
    before(:each) do
      pending "This doesn't work" do
   #   ActionView::InlineTemplate.any_instance.should_receive(:relative_path).and_return("/")
        @controller.template.should_not_receive(:relative_path)
        render(:inline => "<%= link_to_function 'fake_name' {|page| page.rjs_insert_asset('fake_parent')}  %>", :helpers => "LinksAndAttachmentsHelper")
      end
    end



    it 'should render add rjs to the bottom' do
      
      response.should have_rjs(:insert, :bottom, :assets)
      response.should have_rjs(:insert, :bottom, :assets)


    end

  end

  describe 'links_and_attachments' do
    it 'display links to links and attachments' do
      pending
                       

    end
  end



end

describe LinksAndAttachmentsHelper do
  include LinksAndAttachmentsHelper
  it 'add_asset_link shoudl call link_to_function with name' do
    self.should_receive(:link_to_function).with('fake_name').and_return('result')
    add_asset_link('fake_name', 'fake_parent').should == 'result'

  end


end

