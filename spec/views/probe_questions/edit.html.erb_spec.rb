require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/probe_questions/edit.html.erb" do
  include ProbeQuestionsHelper
  
  before(:each) do
    assigns[:probe_question] = @probe_question = stub_model(ProbeQuestion,
      :new_record? => false,
      :probe_definition => ,
      :number => "1",
      :operator => "value for operator",
      :question_text => "value for question_text",
      :question_code => "value for question_code",
      :first_digit => "1",
      :second_digit => "1"
    )
  end

  it "should render edit form" do
    render "/probe_questions/edit.html.erb"
    
    response.should have_tag("form[action=#{probe_question_path(@probe_question)}][method=post]") do
      with_tag('input#probe_question_probe_definition[name=?]', "probe_question[probe_definition]")
      with_tag('input#probe_question_number[name=?]', "probe_question[number]")
      with_tag('input#probe_question_operator[name=?]', "probe_question[operator]")
      with_tag('textarea#probe_question_question_text[name=?]', "probe_question[question_text]")
      with_tag('input#probe_question_question_code[name=?]', "probe_question[question_code]")
      with_tag('input#probe_question_first_digit[name=?]', "probe_question[first_digit]")
      with_tag('input#probe_question_second_digit[name=?]', "probe_question[second_digit]")
    end
  end
end


