require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'check_box_group_matcher' do
  it 'should find matching check box group' do
    response = mock_model(Object, :body => check_box_html)
    response.should have_check_box_group('user[genre_ids][]', [['1', 'Rock/Pop General'], ['2', 'Modern "Alternative"'], ['4', 'Metal']])
  end

  describe 'passed wrong target name' do
    it 'should not match' do
      response = mock_model(Object, :body => check_box_html)
      response.should_not have_check_box_group('wrong name', [['1', 'Rock/Pop General'], ['2', 'Modern "Alternative"'], ['4', 'Metal']])
    end
  end

  describe 'passed non-matching expected' do
    it 'should not match' do
      response = mock_model(Object, :body => check_box_html)
      response.should_not have_check_box_group('user[genre_ids][]', [['1', 'Rock/Pop New Wave'], ['2', 'Modern "Alternative"'], ['4', 'Metal']])
    end
  end

  describe 'with normal failure' do
    it 'should raise ExpectationNotMetError with correct message' do
      response = mock_model Object, :body => 'Some non-matching HTML'
      lambda do
        response.should have_check_box_group('user[genre_ids][]', [['1', 'Rock/Pop General'], ['2', 'Modern "Alternative"'], ['4', 'Metal']])
      end.should raise_error(Spec::Expectations::ExpectationNotMetError, "\nWrong check box group contents.\nexpected: [[\"1\", \"Rock/Pop General\"], [\"2\", \"Modern \\\"Alternative\\\"\"], [\"4\", \"Metal\"]]\n   found: []\n\n")
    end
  end

  describe 'with negative failure' do
    it 'should raise ExpectationNotMetError' do
      response = mock_model Object, :body => check_box_html
      lambda{response.should_not have_check_box_group('user[genre_ids][]', [['1', 'Rock/Pop General'], ['2', 'Modern "Alternative"'], ['4', 'Metal']])}.should raise_error(Spec::Expectations::ExpectationNotMetError,
        "\nShould not have matched check box group: name: user[genre_ids][], with: [[\"1\", \"Rock/Pop General\"], [\"2\", \"Modern \\\"Alternative\\\"\"], [\"4\", \"Metal\"]]\n\n")
    end
  end

  private

  def check_box_html
    %{<div>
      <input id="genre_1" name="user[genre_ids][]" type="checkbox" value="1" />
      <label for="genre_1">Rock/Pop General</label>
    </div>

    <div>
      <input id="genre_2" name="user[genre_ids][]" type="checkbox" value="2" />
      <label for="genre_2">Modern "Alternative"</label>
    </div>

    <div>
      <input id="genre_4" name="user[genre_ids][]" type="checkbox" value="4" />
      <label for="genre_4">Metal</label>
    </div>}
  end
end