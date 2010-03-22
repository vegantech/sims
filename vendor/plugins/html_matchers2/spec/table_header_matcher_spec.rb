require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'table_header_matcher' do
  describe 'with <thead> element' do
    it 'should have headers' do
      verify_table_header_match 'my_id', '<table id="my_id"><thead><tr><th>h1</th><th>h2</th></tr></thead></table>', [['h1', 'h2']]
    end
  end

  describe 'without <thead> element' do
    it 'should not require <thead>' do
      verify_table_header_match 'my_id', '<table id="my_id"><tr><th>h1</th><th>h2</th></tr></table>', [['h1', 'h2']]
    end

    it 'should ignore regular row' do
      verify_table_header_match 'my_id',
                                '<table id="my_id"><tr><th>h1</th><th>h2</th></tr><tr><td>"regular"</td><td>"row"</td></tr></table>',
                                [['h1', 'h2']]
    end

    it 'should handle multiple header rows' do
      verify_table_header_match 'my_id',
        '<table id="my_id"><tr><th>h1</th><th>h2</th></tr><tr><th>h3</th><th>h4</th></tr><tr><td>"regular"</td><td>"row"</td></tr></table>',
        [['h1', 'h2'], ['h3', 'h4']]
    end

    it 'should match "<br/>" to "\n"' do
      verify_table_header_match 'my_id',
        '<table id="my_id"><tr><th>h1 - row 1<br/>h1 - row 2</th></tr></table>',
        [["h1 - row 1\nh1 - row 2"]]
    end

    it 'should match "<br />" to "\n"' do
      verify_table_header_match 'my_id',
        "<table id='my_id'><tr><th>h1 - row 1<br />h1 - row 2</th></tr></table>",
        [["h1 - row 1\nh1 - row 2"]]
    end

    it 'should throw away any amount of white space around a br element' do
      verify_table_header_match 'my_id',
        "<table id='my_id'><tr><th>h1 - row 1    <br/>\t\th1 - row 2</th></tr></table>",
        [["h1 - row 1\nh1 - row 2"]]
    end

    it 'should throw away any amount of white space spanning new lines' do
      verify_table_header_match 'my_id',
        "<table id='my_id'><tr><th>h1 - row 1 \n   <br/>\n      \t\th1 - row 2</th></tr></table>",
        [["h1 - row 1\nh1 - row 2"]]
    end
  end

  describe 'passed wrong id' do
    it 'should not have header' do
      verify_no_header_match 'wrong_id', '<table id="my_id"><tr><th>h1</th><th>h2</th></tr></table>', [['h1', 'h2']]
    end
  end

  describe 'with normal failure' do
    it 'should raise ExpectationNotMetError with correct message' do
      response = mock_model Object, :body => 'Some non-matching HTML'
      lambda do
        response.should have_table_header('id', [['h1', 'h2']])
      end.should raise_error(Spec::Expectations::ExpectationNotMetError, "\nWrong table header contents.\nexpected: [[\"h1\", \"h2\"]]\n   found: []\n\n")
    end
  end

  describe 'with negative failure' do
    it 'should raise ExpectationNotMetError' do
      response = mock_model Object, :body => '<table id="my_id"><tr><th>h1</th><th>h2</th></tr></table>'
      lambda{response.should_not have_table_header('my_id', [['h1', 'h2']])}.should raise_error(Spec::Expectations::ExpectationNotMetError,
        "\nTable header should not have matched: [[\"h1\", \"h2\"]]\n")
    end
  end

  describe 'passed nil expected' do
    it 'should raise error' do
      response = mock_model(Object, :body => '<table id="my_id"><tr><th>h1</th><th>h2</th></tr></table>')
      lambda{ response.should have_table_header('my_id', nil)}.should raise_error(RuntimeError, 'Invalid "expected" argument')
    end
  end

  describe 'called from nil response object' do
    it 'should raise error' do
      lambda{ nil.should have_table_header('my_id', [['h1', 'h2']]) }.should raise_error(NoMethodError,
        "You have a nil object when you didn't expect it!\nThe error occurred while evaluating nil.body")
    end
  end

  describe 'when headers don\'t match' do
    it 'should not match' do
      verify_no_header_match 'my_id', '<table id="my_id"><tr><th>h1</th><th>h2</th></tr></table>', [['h1', 'h3']]
    end
  end

  it "doesn't require table_id" do
    response = mock_model Object, :body => '<table id="my_id"><tr><th>h1</th><th>h2</th></tr></table>'
    response.should have_table_header([['h1', 'h2']])
  end

  private

  def verify_table_header_match id, html, expected
    response = mock_model Object, :body => html
    response.should have_table_header(id, expected)
  end

  def verify_no_header_match id, html, expected
    response = mock_model Object, :body => html
    response.should_not have_table_header(id, expected)
  end
end
