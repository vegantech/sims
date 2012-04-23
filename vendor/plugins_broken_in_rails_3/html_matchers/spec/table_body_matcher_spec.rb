require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'table_body_matcher' do
  describe 'with <tbody> element' do
    it 'should find body rows' do
      response = mock_model(Object, :body => '<table id="my_id"><tbody><tr><td>c1</td><td>c2</td></tr></tbody></table>')
      response.should have_table_body('my_id', [['c1', 'c2']])
    end
  end

  describe 'without <tbody> element' do
    it 'should not require <tbody>' do
      response = mock_model(Object, :body => '<table id="my_id"><tr><td>c1</td><td>c2</td></tr></table>')
      response.should have_table_body('my_id', [['c1', 'c2']])
    end

    describe 'with extraneous multiline whitespace' do
      it 'should remove extraneous whitespace' do
        response = mock_model(Object, :body => "<table id='my_id'><tr><td>\n  c1a\n   \t<br/>   \tc1b</td><td>c2</td></tr></table>")
        response.should have_table_body('my_id', [["c1a\nc1b", 'c2']])
      end
    end

    it 'should ignore header row' do
      response = mock_model(Object, :body => '<table id="my_id"><tr><th>h1</th><th>h2</th></tr><tr><td>c1</td><td>c2</td></tr></table>')
      response.should have_table_body('my_id', [['c1', 'c2']])
    end
  end

  it 'can be called without a table_id' do
    response = mock_model(Object, :body => '<table><tr><td>c1</td><td>c2</td></tr></table>')
    response.should have_table_body([['c1', 'c2']])
  end

  it 'matches multiple body rows' do
    response = mock_model(Object, :body => '<table><tr><td>c1</td><td>c2</td></tr><tr><td>c3</td><td>c4</td></tr></table>')
    response.should have_table_body([['c1', 'c2'], ['c3', 'c4']])
  end

  describe 'passed wrong id' do
    it 'should not match' do
      response = mock_model(Object, :body => '<table id="my_id"><tr><td>c1</td><td>c2</td></tr></table>')
      response.should_not have_table_body('wrong_id', [['c1', 'c2']])
    end
  end

  describe 'passed non-matching expected' do
    it 'should not match' do
      response = mock_model(Object, :body => '<table id="my_id"><tr><td>c1</td><td>c2</td></tr></table>')
      response.should_not have_table_body('my_id', [['c3', 'c2']])
    end
  end

  describe 'with normal failure' do
    it 'should raise ExpectationNotMetError with correct message' do
      response = mock_model Object, :body => 'Some non-matching HTML'
      lambda do
        response.should have_table_body('my_id', [['c1', 'c2']])
      end.should raise_error(Spec::Expectations::ExpectationNotMetError, "\nWrong table body contents.\nexpected: [[\"c1\", \"c2\"]]\n   found: []\n\n")
    end
  end

  describe 'with negative failure' do
    it 'should raise ExpectationNotMetError' do
      response = mock_model Object, :body => '<table id="my_id"><tr><td>c1</td><td>c2</td></tr></table>'
      lambda{response.should_not have_table_body('my_id', [['c1', 'c2']])}.should raise_error(Spec::Expectations::ExpectationNotMetError,
        "\nTable body should not have matched: [[\"c1\", \"c2\"]]\n")
    end
  end

  describe 'passed nil expected' do
    it 'should raise error' do
      response = mock_model(Object, :body => '<table id="my_id"><tr><td>c1</td><td>c2</td></tr></table>')
      lambda{ response.should have_table_body('my_id', nil)}.should raise_error(RuntimeError, 'Invalid "expected" argument')
    end
  end
end
