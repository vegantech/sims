require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe DistrictUploadJob do
  describe 'perform' do
    it 'should use default email if present but blank'
    it 'should use provided email'
    it 'should not send email if email is false'
    it 'should call import'
    it 'should handle exceptions'
  end
end
