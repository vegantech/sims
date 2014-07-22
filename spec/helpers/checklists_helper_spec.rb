require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChecklistsHelper do
  include ChecklistsHelper
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(ChecklistsHelper)
  end

  it "should display autoset message if answer_definition has it present" do
    answer_definition=mock_model(AnswerDefinition,"autoset_others?"=>true)
    autoset_message(answer_definition).should match(/answer/)
  end

  it "should not display autoset message if answer_definition has it present" do
    answer_definition=mock_model(AnswerDefinition,"autoset_others?" =>false)
    autoset_message(answer_definition). should ==(nil)
  end

  it "should set the class for incorrect answer" do
    incorrect_answer_highlight.should ==('class="incorrectAnswer"')
  end

  it "should highlight only if wrong element" do
    self.should_receive("correct_question?").and_return(false)
    highlight_if_wrong_question("c","qd").should ==(incorrect_answer_highlight)
  end

  it "should not highlight if correct element" do
    self.should_receive("correct_question?").and_return(true)
    highlight_if_wrong_question("c","qd").should ==(nil)
  end

  it 'should return true for correct_question? on a unscored checklist' do
    correct_question?(Checklist.new, QuestionDefinition.new).should == true
  end

  it 'should return true for correct_element if question is correct' do
    self.should_receive("correct_question?").and_return(true)
    correct_element?(Checklist.new, QuestionDefinition.new, ElementDefinition.new).should == true
  end

  it 'should return incorrect_answer_highlight if correct_element is false' do
    self.should_receive(:correct_element?).with(1,2,3).and_return(true)
    highlight_if_wrong_element(1,2,3).should == nil
    self.should_receive(:correct_element?).with(6,7,8).and_return(false)
    highlight_if_wrong_element(6,7,8).should == incorrect_answer_highlight

  end

  describe 'markdown_with_span' do
    it 'should return markdown text wrapped in a span' do
      pending
      markdown_with_span('text to display').should == '<span class="markdown"><p>text to display</p></span>'

    end
  end

  describe 'with bluecloth defined' do
    it 'should show markdown note' do
      markdown_note.should match(/markdown/)
    end

  end

end
=begin

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../../test_helper'
require File.dirname(__FILE__) + '/../../helper_testcase'


class ChecklistsHelperTest < HelperTestCase
  include ChecklistsHelper

  def setup
    @question_definition=QuestionDefinition.new
    @element_definition=ElementDefinition.new
    @checklist=Checklist.new(:score_results=>{@question_definition=>{@element_definition=>"reason"}})
  end

  def test_incorrect_answer_highlight
    assert_equal 'class="incorrectAnswer"', incorrect_answer_highlight
  end

  def test_correct_element
    assert correct_element?(Checklist.new,QuestionDefinition.new, ElementDefinition.new)
    assert !correct_element?(@checklist, @question_definition, @element_definition)
  end

  def test_reason_if_wrong_element
    assert_match /--- reason/, reason_if_wrong_element(@checklist,@question_definition,@element_definition)
    assert_equal "", reason_if_wrong_element(Checklist.new,QuestionDefinition.new, ElementDefinition.new)
  end

  def test_highlight_if_wrong_element
    assert_equal incorrect_answer_highlight,
    highlight_if_wrong_element(@checklist, @question_definition, @element_definition)
  end

  def test_correct_question?
    assert correct_question?(Checklist.new,QuestionDefinition.new)
    assert !correct_question?(@checklist,@question_definition)
  end

  def test_highlight_if_wrong_question
    assert_equal nil, highlight_if_wrong_question(@checklist,0)
    assert_equal incorrect_answer_highlight, highlight_if_wrong_question(@checklist,@question_definition)
  end

  def test_autoset_onclick_without_autoset
    assert_equal   autoset_onclick(QuestionDefinition.new, AnswerDefinition.new), {:onclick=>nil}
  end

  def test_autoset_onclick_autoset

    qd=QuestionDefinition.new(:question_definition_id=>55)
    p={:question_definition_id=>55,:kind=>"scale",:text=>"blah"}
    ed=qd.element_definitions.build(p.merge(:element_definition_id=>55))
    ed.save!
    ed2=qd.element_definitions.build(p.merge(:element_definition_id=>56))
    ed2.save!
    answer1=ed.answer_definitions.create!(:autoset_others=>true,:value=>1)
    answer2=ed2.answer_definitions.create!(:autoset_others=>true,:value=>1)
    results = autoset_onclick(qd, answer1)
    assert_match /element_definition/, results[:onclick]
  end


=begin
  def setup
    @cols=Struct.new(:name)
  end

  def test_probe_definition_columns_to_list
    no_list_columns = %w{calendarID created_at active updated_at}
    list_columns = %w{ curly larry moe }
    no_list_columns.each do |col|
      assert_equal nil, (probe_definition_columns_to_list(@cols.new(col)) {"blah"})
    end
    list_columns.each do |col|
      assert_equal "blah", (probe_definition_columns_to_list(@cols.new(col)) {"blah"})
    end


  end

  def test_probe_definition_columns_to_show
    no_list_columns = %w{calendarID active}
    list_columns = %w{ curly larry moe }

    no_list_columns.each do |col|
      assert_equal nil, (probe_definition_columns_to_list(@cols.new(col)) {"blah"})
    end
    list_columns.each do |col|
      assert_equal "blah", (probe_definition_columns_to_list(@cols.new(col)) {"blah"})

    end
  end


  def test_display_calendar_id
    session={:isPrincipal=>true}
    assert_equal "blah",(display_calendar_id(session) {"blah"})
    session={}
    assert_equal nil,(display_calendar_id(session) {"blah"})
  end

  def test_probe_definitions_to_show
    session={}
    @pd=ProbeDefinition.new(:author_id=>2,:calendarID=>6)
    assert_equal nil,(probe_definitions_to_show(@pd,session) {"blah"})
    session[:isPrincipal]=true
    assert_equal nil,(probe_definitions_to_show(@pd,session) {"blah"})
    @pd.calendarID = session[:calendarID] = 1
    assert_equal "blah",(probe_definitions_to_show(@pd,session) {"blah"})
    @pd.author_id=session[:user_id] = 1
    session[:isPrincipal]=false
    assert_equal "blah",(probe_definitions_to_show(@pd,session) {"blah"})
    session[:user_id]=nil
    assert_equal nil,(probe_definitions_to_show(@pd,session) {"blah"})

  end
=end
