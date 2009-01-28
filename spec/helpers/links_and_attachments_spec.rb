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
    def link_to_with_icon(name, url)
      "#{name} -- #{url}"
    end
    it 'display nothing when there are no assets' do
      k=mock_object(:assets=>[])
      links_and_attachments(k,:blink).should be_blank
    end

    it 'should display a link when the object has 1 asset with just a link' do
      document = mock_object(:original_filename=>"original_filename", :url=>"new_doc_url")
      
      
      empty_asset=mock_asset(:url=>nil, 'document?'=>false)
      link_asset=mock_asset('document?' =>false, :name=> 'link_asset', :url => 'www.link_asset.ant')
      attach_asset=mock_asset(:url=>nil, :document => document, 'document?'=>true)
      both_asset=mock_asset(:name=>'both_asset', :url =>'www.both_asset.mil',:document => document, 'document?' => true)
      object=mock_object(:assets=>[link_asset,both_asset,empty_asset,attach_asset])

      links_and_attachments(object, :dict).should == "<dict>link_asset -- www.link_asset.ant</dict><dict>both_asset -- www.both_asset.mil</dict><dict>original_filename -- new_doc_url</dict><dict>original_filename -- new_doc_url</dict>"

    end
    
  end
end

