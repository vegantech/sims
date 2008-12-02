require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RJSBuilderHelper do
  include RJSBuilderHelper

  class HelperRJSPageProxy
    def initialize(context)
      @context = context
    end

      def method_missing(method, *arguments)
        block = Proc.new { |page|  @lines = []; page.send(method, *arguments) }
        @context.response.body = ActionView::Helpers::PrototypeHelper::JavaScriptGenerator.new(@context, &block).to_s
        @context.response
      end
  end 

  
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(RJSBuilderHelper)
  end

  it 'should smoke test, note this is somewhat useless' do

    self.stub!("template_format=",'')
    self.stub!("template_format",'')
    %w{safe_highlight update_content insert_content remove_content blind_down blind_up remove_content_if_visible}.each do |method|
      HelperRJSPageProxy.new(self).send(method,"dom_id").body.should match(/dom_id/)
    end

    %w{change_link insert_or_update_error_content}.each do |method|
      HelperRJSPageProxy.new(self).send(method,"dom_id",'other').body.should match(/dom_id/)
    end

    %w{if_visible if_not_visible}.each do |method|
      self.send(method,"dom_id").should match(/dom_id/)
    end

    HelperRJSPageProxy.new(self).send(:remove_content_and_change_link_if_visible,"old_dom_id","new_dom_id","text").body.should match(/dom_id/)






    pending 'do something better'
  end


end
