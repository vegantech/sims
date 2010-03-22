require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'drop_down_matcher' do
  it 'should find matching dropdown' do
    response = mock_model(Object, :body => '<select id="choice"><option value="val1">Choice 1</option><option value="val2">Choice 2</option></select>')
    response.should have_dropdown('choice', ['Choice 1', 'Choice 2'])
  end

  describe 'passed wrong id' do
    it 'should not match' do
      response = mock_model(Object, :body => '<select id="choice"><option value="val1">Choice 1</option><option value="val2">Choice 2</option></select>')
      response.should_not have_dropdown('wrong_id', ['Choice 1', 'Choice 2'])
    end
  end

  describe 'with non-matching expected' do
    it 'should not match' do
      response = mock_model(Object, :body => '<select id="choice"><option value="val1">Choice 1</option><option value="val2">Choice 2</option></select>')
      response.should_not have_dropdown('choice', ['Not A Match 1', 'Not A Match 2'])
    end
  end

  describe 'without matching select element' do
    it 'should raise ExpectationNotMetError with correct message' do
      response = mock_model Object, :body => 'Some non-matching HTML'
      lambda do
        response.should have_dropdown('choice', [['Choice 1', 'Choice 2']])
      end.should raise_error(Spec::Expectations::ExpectationNotMetError, "\nCould not find a select element with id: 'choice'\n\n")
    end
  end

  describe 'with wrong contents in correct select element' do
    it 'should raise ExpectationNotMetError with correct message' do
      response = mock_model Object, :body => '<select id="choice"><option value="no_match">No Match</option></select>'
      lambda do
        response.should have_dropdown('choice', [['Choice 1', 'Choice 2']])
      end.should raise_error(Spec::Expectations::ExpectationNotMetError, "\nWrong 'choice' drop down contents.\nexpected: [[\"Choice 1\", \"Choice 2\"]]\n   found: [\"No Match\"]\n\n")
    end
  end

  describe 'with negative failure' do
    it 'should raise ExpectationNotMetError' do
      response = mock_model Object, :body => '<select id="choice"><option value="val1">Choice 1</option><option value="val2">Choice 2</option></select>'
      lambda{response.should_not have_dropdown('choice', ['Choice 1', 'Choice 2'])}.should raise_error(Spec::Expectations::ExpectationNotMetError,
        "\nShould not have matched dropdown with id: choice\n\tand contents: [\"Choice 1\", \"Choice 2\"]\n\n")
    end
  end
end