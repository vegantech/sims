require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LinksAndAttachmentsHelper do

  describe 'add_asset_link' do
    it 'add_asset_link should call link_to_function with name' do
      mu=mock_user
      helper.should_receive(:current_user).and_return(mu)
      helper.add_asset_link('fake_name', 'fake_parent').should ==
        "<div class=\"hidden_asset\" style=\"display:none\"><div class=\"asset \">\n      <p>\n       <br />\n\n      <label for=\"fake_parent_new_asset_attributes__document\">File:</label>\n      <input id=\"fake_parent_new_asset_attributes__document\" name=\"fake_parent[new_asset_attributes][][document]\" type=\"file\" /> <br />\n\n      <label for=\"fake_parent_new_asset_attributes__name\">Name for url</label>\n      <input id=\"fake_parent_new_asset_attributes__name\" name=\"fake_parent[new_asset_attributes][][name]\" size=\"30\" type=\"text\" /> <br />\n\n      <label for=\"fake_parent_new_asset_attributes__url\">Url</label>\n      <input id=\"fake_parent_new_asset_attributes__url\" name=\"fake_parent[new_asset_attributes][][url]\" size=\"30\" type=\"text\" />\n      <input id=\"fake_parent_new_asset_attributes__user_id\" name=\"fake_parent[new_asset_attributes][][user_id]\" type=\"hidden\" value=\"#{mu.id}\" />\n      <a href=\"#\" class=\"cancel_link\" data-remove-up=\".hidden_asset\">remove</a>\n      </p>\n</div>\n</div><a href=\"\" class=\"new_asset_link\" data-parent=\"fake_parent\" data-suffix=\"\">fake_name</a>"

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
      object=mock(:assets=>[link_asset,both_asset,empty_asset,attach_asset], :show_asset_info? => false)

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

