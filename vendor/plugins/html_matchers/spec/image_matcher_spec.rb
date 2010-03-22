require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'image_matcher' do
  it 'should find matching image' do
    response = mock_model(Object, :body => '<p><img id="image_id" src="/images/my_photo.jpg?1233455"/></p>')
    response.should have_image('my_photo.jpg')
  end
  
  describe 'with non-matching expected' do
    it 'should not match' do
      response = mock_model(Object, :body => '<p><img id="image_id" src="/images/my_photo.jpg?1233455"/></p>')
      response.should_not have_image('my_other_photo.gif')
    end
  end
  
  describe 'with normal failure' do
    it 'should raise ExpectationNotMetError with correct message' do
      response = mock_model Object, :body => 'Some non-matching HTML'
      lambda do
        response.should have_image('my_photo.jpg')
      end.should raise_error(Spec::Expectations::ExpectationNotMetError, "\nWrong image path.\nexpected: \"my_photo.jpg\"\n   found: nil\n\n")
    end
  end

  describe 'with negative failure' do
    it 'should raise ExpectationNotMetError' do
      response = mock_model Object, :body => '<p><img id="image_id" src="/images/my_photo.jpg?1233455"/></p>'
      lambda do
        response.should_not have_image('my_photo.jpg')
      end.should raise_error(Spec::Expectations::ExpectationNotMetError,
        "\nShould not have matched image with path: 'my_photo.jpg'\n\n")
    end
  end
end