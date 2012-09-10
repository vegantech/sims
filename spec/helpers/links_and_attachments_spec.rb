require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LinksAndAttachmentsHelper do


  describe 'add_asset_link' do
    it 'add_asset_link should call link_to_function with name' do
      helper.should_receive(:link_to_function).with('fake_name').and_return('result')
      helper.add_asset_link('fake_name', 'fake_parent').should == 'result'
    end

    it 'should render add rjs to the bottom' do
      helper.should_receive(:render).and_return('RENDERED_CONTENT')
      resp=fake_update_page(:append_asset_link,'fake_parent')
      resp.should == 'Element.insert("assets", { bottom: "RENDERED_CONTENT" });'
    end

    it 'should call append_asset_link on page' do
      helper.should_receive(:add_asset_link).and_return("AppendAssetLink")
      helper.add_asset_link('one','two').should ==  'AppendAssetLink'
    end

  end

  def fake_update_page(method,*args)
    helper.update_page do |page|
#     page!(:page=>page)
      page.send(method, *args)
    end
  end

  describe 'links_and_attachments' do
    it 'display nothing when there are no assets' do
      k=mock(:assets=>[])
      helper.links_and_attachments(k,:blink).should be_blank
    end

    it 'should display a link when the object has 1 asset with just a link' do
      def helper.link_to_with_icon(name, url)
        "#{name} -- #{url}"
      end
      document = mock(:original_filename=>"original_filename", :url=>"new_doc_url", :content_type=>'blah')


      empty_asset=mock_asset(:url=>nil, 'document?'=>false)
      link_asset=mock_asset('document?' =>false, :name=> 'link_asset', :url => 'www.link_asset.ant')
      attach_asset=mock_asset(:url=>nil, :document => document, 'document?'=>true)
      both_asset=mock_asset(:name=>'both_asset', :url =>'www.both_asset.mil',:document => document, 'document?' => true)
      object=mock(:assets=>[link_asset,both_asset,empty_asset,attach_asset])

      helper.links_and_attachments(object, :dict).should == "<dict>link_asset -- www.link_asset.ant</dict><dict>both_asset -- www.both_asset.mil</dict><dict>original_filename -- new_doc_url</dict><dict>original_filename -- new_doc_url</dict>"
    end

    it 'should not display anything when the assets are destroyed' do
      comment = StudentComment.new
      asset = comment.assets.build(:url => 'test', :name => 'test')
      asset.destroy
      comment.assets.should_not be_empty
      helper.links_and_attachments(comment, :dict).should == ''
    end

  end
end

