require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'radio_group_matcher' do
  it 'should find matching radio group' do
    response = mock_model(Object, :body => '<p><b>Gender</b><br/>M <input id="athlete_gender_m" name="athlete[gender]" type="radio" value="M" /><br/>F <input id="athlete_gender_f" name="athlete[gender]" type="radio" value="F" /></p>')
    response.should have_radio_group('athlete[gender]', ['M', 'F'])
  end

  describe 'passed wrong id' do
    it 'should not match' do
      response = mock_model(Object, :body => '<p><b>Gender</b><br/>M <input id="athlete_gender_m" name="athlete[gender]" type="radio" value="M" /><br/>F <input id="athlete_gender_f" name="athlete[gender]" type="radio" value="F" /></p>')
      response.should_not have_radio_group('wrong_id', ['M', 'F'])
    end
  end

  describe 'with non-matching expected' do
    it 'should not match' do
      response = mock_model(Object, :body => '<p><b>Gender</b><br/>M <input id="athlete_gender_m" name="athlete[gender]" type="radio" value="M" /><br/>F <input id="athlete_gender_f" name="athlete[gender]" type="radio" value="F" /></p>')
      response.should_not have_radio_group('athlete[gender]', ['M', 'O'])
    end
  end

  describe 'with normal failure' do
    it 'should raise ExpectationNotMetError with correct message' do
      response = mock_model Object, :body => 'Some non-matching HTML'
      lambda do
        response.should have_radio_group('athlete[gender]', ['M', 'F'])
      end.should raise_error(Spec::Expectations::ExpectationNotMetError, "\nWrong radio group contents.\nexpected: [\"M\", \"F\"]\n   found: []\n\n")
    end
  end

  describe 'with negative failure' do
    it 'should raise ExpectationNotMetError' do
      response = mock_model Object, :body => '<p><b>Gender</b><br/>M <input id="athlete_gender_m" name="athlete[gender]" type="radio" value="M" /><br/>F <input id="athlete_gender_f" name="athlete[gender]" type="radio" value="F" /></p>'
      lambda{response.should_not have_radio_group('athlete[gender]', ['M', 'F'])}.should raise_error(Spec::Expectations::ExpectationNotMetError,
        "\nShould not have matched radio group: name: athlete[gender], with: [\"M\", \"F\"]\n\n")
    end
  end
end