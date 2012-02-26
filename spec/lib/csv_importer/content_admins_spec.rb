require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/roles_base.rb')

describe CSVImporter::ContentAdmins do
  include_context "role importer"

  def myclass
    CSVImporter::ContentAdmins
  end

  def role
    "content_admin"
  end

  it 'should have the correct role' do
    @i.send(:role).should == role
  end
end

