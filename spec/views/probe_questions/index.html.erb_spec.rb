require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/probe_questions/index.html.erb" do
  include ProbeQuestionsHelper
  
  before(:each) do
    assigns[:probe_questions] = [
      stub_model(ProbeQuestion,
        :probe_definition => ,
        :number => "1",
        :operator => "value for operator",
        :question_text => "value for question_text",
        :question_code => "value for question_code",
        :first_digit => "1",
        :second_digit => "1"
      ),
      stub_model(ProbeQuestion,
        :probe_definition => ,
        :number => "1",
        :operator => "value for operator",
        :question_text => "value for question_text",
        :question_code => "value for question_code",
        :first_digit => "1",
        :second_digit => "1"
      )
    ]
  end

  it "should render list of probe_questions" do
    render "/probe_questions/index.html.erb"
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "value for operator", 2)
    response.should have_tag("tr>td", "value for question_text", 2)
    response.should have_tag("tr>td", "value for question_code", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

