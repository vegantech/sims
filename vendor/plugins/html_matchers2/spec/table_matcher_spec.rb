require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'table_matcher' do
  describe 'with <thead> and <tbody> elements' do
    it 'should find header and body rows' do
      response = mock_model(Object, :body => '<table id="my_id"><thead><tr><th>h1</th><th>h2</th></tr></thead><tbody><tr><td>c1</td><td>c2</td></tr></tbody></table>')
      response.should have_table('#my_id', [['h1', 'h2'], ['c1', 'c2']])
    end
  end

  describe 'without <thead> and <tbody> elements' do
    it 'should work' do
      response = mock_model(Object, :body => '<table id="my_id"><tr><th>h1</th><th>h2</th></tr><tr><td>c1</td><td>c2</td></tr></table>')
      response.should have_table('#my_id', [['h1', 'h2'], ['c1', 'c2']])
    end

    describe 'with extraneous multiline whitespace' do 
      it 'should remove extraneous whitespace' do
        response = mock_model(Object, :body => "<table id=\"my_id\"><tr><th>h1</th><th>h2</th></tr><tr><td>\n  c1a\n   \t<br/>   \tc1b</td><td>c2</td></tr></table>")
        response.should have_table('#my_id', [['h1', 'h2'], ["c1a\nc1b", 'c2']])
      end
    end

    describe 'with inline script tags in a header cell' do
      it "should suppress script content" do
        response = mock_model(Object, :body => '<table id="my_id"><tr><th>h1</th><th>h2a<script type="text/javascript">
          //<![CDATA[
          x = 1;
          //]]>
          </script>
          h2b</th></tr><tr><td>c1</td><td>c2</td></tr></table>')
        response.should have_table('#my_id', [['h1', "h2a\nh2b"], ["c1", "c2"]])
      end
    end

    describe 'with inline script tags in a cell' do
      it "should suppress script content" do
        response = mock_model(Object, :body => '<table id="my_id"><tr><th>h1</th><th>h2</th></tr><tr><td>c1a<script type="text/javascript">
          //<![CDATA[
          x = 1;
          //]]>
          </script>
          c1b</td></tr></table>')
        response.should have_table('#my_id', [['h1', 'h2'], ["c1a\nc1b"]])
      end
    end
  end

  it 'can be called without a table_id' do
    response = mock_model(Object, :body => '<table><tr><td>c1</td><td>c2</td></tr></table>')
    response.should have_table([['c1', 'c2']])
  end

  it 'matches multiple body rows' do
    response = mock_model(Object, :body => '<table><tr><td>c1</td><td>c2</td></tr><tr><td>c3</td><td>c4</td></tr></table>')
    response.should have_table([['c1', 'c2'], ['c3', 'c4']])
  end

  describe 'passed wrong id' do
    it 'should not match' do
      response = mock_model(Object, :body => '<table id="my_id"><tr><td>c1</td><td>c2</td></tr></table>')
      response.should_not have_table('#wrong_id', [['c1', 'c2']])
    end
  end

  describe 'passed non-matching expected' do
    it 'should not match' do
      response = mock_model(Object, :body => '<table id="my_id"><tr><td>c1</td><td>c2</td></tr></table>')
      response.should_not have_table('#my_id', [['c3', 'c2']])
    end
  end

  describe 'with normal failure' do
    it 'should raise ExpectationNotMetError with correct message' do
      response = mock_model Object, :body => 'Some non-matching HTML'
      lambda do
        response.should have_table('#my_id', [['c1', 'c2']])
      end.should raise_error(Spec::Expectations::ExpectationNotMetError, "\nWrong table contents.\nexpected: [[\"c1\", \"c2\"]]\n   found: []\n\n")
    end
  end

  describe 'with negative failure' do
    it 'should raise ExpectationNotMetError' do
      response = mock_model Object, :body => '<table id="my_id"><tr><td>c1</td><td>c2</td></tr></table>'
      lambda{
        response.should_not have_table('#my_id', [['c1', 'c2']])
      }.should raise_error(Spec::Expectations::ExpectationNotMetError,
        "\nTable should not have matched: [[\"c1\", \"c2\"]]\n")
    end
  end

  describe 'passed nil expected' do
    it 'should raise error' do
      response = mock_model(Object, :body => '<table id="my_id"><tr><td>c1</td><td>c2</td></tr></table>')
      lambda{ response.should have_table('#my_id', nil)}.should raise_error(RuntimeError, 'Invalid "expected" argument')
    end
  end

  describe "using non-id selectors" do
    describe "class" do
      it "matches with class" do
        response = mock_model(Object, :body => '<table class="my_class"><tr><th>h1</th><th>h2</th></tr><tr><td>c1</td><td>c2</td></tr></table>')
        response.should have_table('.my_class', [['h1', 'h2'], ['c1', 'c2']])
      end
      it "does not match when class do not match" do
        response = mock_model(Object, :body => '<table class="my_class_2"><tr><th>h1</th><th>h2</th></tr><tr><td>c1</td><td>c2</td></tr></table>')
        response.should_not have_table('.my_class', [['h1', 'h2'], ['c1', 'c2']])
      end
      it 'should raise ExpectationNotMetError with correct message' do
        response = mock_model Object, :body => 'Some non-matching HTML'
        lambda do
          response.should have_table('.my_id', [['c1', 'c2']])
        end.should raise_error(Spec::Expectations::ExpectationNotMetError, "\nWrong table contents.\nexpected: [[\"c1\", \"c2\"]]\n   found: []\n\n")
      end
    end
  end
end
