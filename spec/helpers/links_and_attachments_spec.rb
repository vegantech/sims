require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LinksAndAttachmentsHelper do
  include LinksAndAttachmentsHelper


  describe 'add_asset_link' do
    it 'add_asset_link should call link_to_function with name' do
      self.should_receive(:link_to_function).with('fake_name').and_return('result')
      add_asset_link('fake_name', 'fake_parent').should == 'result'
    end
    
    it 'should render add rjs to the bottom' do
      @template.should_receive(:render).and_return('RENDERED_CONTENT')
      resp=fake_update_page(:append_asset_link,'fake_parent')
      resp.should == 'Element.insert("assets", { bottom: "RENDERED_CONTENT" });'
    end

    it 'should call append_asset_link on page' do
      add_asset_link('one','two').should ==  '<a href="#" onclick="AppendAssetLink; return false;">one</a>'
    end
    
  end

  def fake_update_page(method,*args)
    update_page do |page|
      self.stub!(:page=>page)
      send(method, *args)
    end
  end

  describe 'links_and_attachments' do
    it 'display links to links and attachments' do
      pending
                       

    end
  end
end

