require 'rubygems'
require 'test/unit'
require 'action_controller'
require 'spell_check'
require 'action_controller/test_case'
require 'action_controller/test_process'
require 'lib/helpers/spell_check_helper'

ActionController::Routing::Routes.clear!
ActionController::Routing::Routes.draw {|m| m.connect ':controller/:action'}
ActionController::Base.view_paths = 'lib/views'

class ApplicationController  < ActionController::Base
 
  include SpellCheckHelper
  def rescue_action(e) 
    raise e
  end

  def rendering_of_partials
    render :partial=>'spell_check/spelling'
  end

  def help
    Helper.new
  end

  class Helper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper
    #    include ActionController::Base
    include SpellCheckHelper
  end
  
  include SpellCheck

end
  

class SpellCheckTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def setup
    @controller = ApplicationController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end


  def test_suggestions
    get :suggestions,  {:word=>"dog"}
    assert assigns['suggestions'].blank?


    get :suggestions,  {:word=>"dogz"}
    assert assigns['suggestions'].include?("dog")
    assert_template('spell_check/_suggestions')
    assert_response :success
    assert_tag :tag => 'ul',:descendant => {:tag =>'li', :child =>"dog"}

    #p @response
    #assert @controller.suggestions
  end

  def test_spellcheck
    @controller.params={}
    assert_equal "Spell check successfully completed Empty Comment", @controller.send("spellcheck")
    assert_equal "Spell check successfully completed on comment ", @controller.send("spellcheck", "dog")
  end

  def test_spellcheck_helper_submit
    a=@controller.help.spellcheck_submit
    assert a.include?('submit')
    assert a.include?('Spell Check')
  end  

  def test_spellcheck_partial
    get :rendering_of_partials
    assert @response.body.include?('span'), @response.body

    assert_raise(NoMethodError) {@controller.help.spellcheck_partial}
    
  end
   
end
    
