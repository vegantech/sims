require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'span_text_matcher' do
  it 'should find matching span' do
    response = mock_model(Object, :body => '<p><span id="span_id">My Text</span></p>')
    response.should have_span_text('span_id', 'My Text')
  end

  describe 'passed wrong id' do
    it 'should not match' do
      response = mock_model(Object, :body => '<p><span id="span_id">My Text</span></p>')
      response.should_not have_span_text('wrong_id', 'My Text')
    end
  end

  describe 'with non-matching expected' do
    it 'should not match' do
      response = mock_model(Object, :body => '<p><span id="span_id">My Text</span></p>')
      response.should_not have_span_text('span_id', 'Some Other Text')
    end
  end

  describe 'with normal failure' do
    it 'should raise ExpectationNotMetError with correct message' do
      response = mock_model Object, :body => 'Some non-matching HTML'
      lambda do
        response.should have_span_text('span_id', 'My Text')
      end.should raise_error(Spec::Expectations::ExpectationNotMetError, "\nWrong span text contents.\nexpected: \"My Text\"\n   found: nil\n\n")
    end
  end

  describe 'with negative failure' do
    it 'should raise ExpectationNotMetError' do
      response = mock_model Object, :body => '<p><span id="span_id">My Text</span></p>'
      lambda{response.should_not have_span_text('span_id', 'My Text')}.should raise_error(Spec::Expectations::ExpectationNotMetError,
        "\nShould not have matched span: span_id, with text: 'My Text'\n\n")
    end
  end
end