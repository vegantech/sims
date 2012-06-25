require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RJSBuilderHelper do
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(RJSBuilderHelper)
  end



  def fake_update_page(method,*args)
    helper.update_page do |page|
      self.stub!(:page=>page)
      send(method, *args)
    end
  end
  describe 'should smoke test, note this is somewhat useless:' do
    #    pending "Doesn't work in Rails 2.2?"

    %w{safe_highlight update_content insert_content remove_content blind_down blind_up remove_content_if_visible}.each do |method|

      it method do
        fake_update_page(method,"The_dom_id").should match(/The_dom_id/)
        pending "This is just a smoke test, we need to really test these."
      end
    end


    %w{insert_or_update_error_content}.each do |method|
      it method do
        fake_update_page(method,"The_dom_id",'other').should match(/The_dom_id/)
        pending "This is just a smoke test, we need to really test these."
      end
    end

    it 'change_link' do
      pending "Smoke test failed,   figure out why and add it back to the above block"
    end


    %w{if_visible if_not_visible}.each do |method|
      it method do
        send(method,"The_dom_id").should match(/The_dom_id/)
        pending "This is just a smoke test, we need to really test these."
      end
    end

    %w{remove_content_and_change_link_if_visible}.each do |method|
      it method do
        fake_update_page(method,"old_dom_id","new_dom_id","text").should match(/old_dom_id/)
        pending "This is just a smoke test, we need to really test these."
      end
    end
  end

end
