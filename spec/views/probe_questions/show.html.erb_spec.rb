require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/probe_questions/show.html.erb" do
  include ProbeQuestionsHelper
  
  before(:each) do
    assigns[:probe_question] = @probe_question = stub_model(ProbeQuestion,
      :probe_definition => ,
      :number => "1",
      :operator => "value for operator",
      :question_text => "value for question_text",
      :question_code => "value for question_code",
      :first_digit => "1",
      :second_digit => "1"
    )
  end

  it "should render attributes in <p>" do
    render "/probe_questions/show.html.erb"
    response.should have_text(//)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ operator/)
    response.should have_text(/value\ for\ question_text/)
    response.should have_text(/value\ for\ question_code/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end

