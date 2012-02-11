require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/roles_base.rb')

describe CSVImporter::SchoolAdmins do
  include_context "role importer"

  def myclass
    CSVImporter::SchoolAdmins
  end

  def role
    "school_admin"
  end

  it 'should have the correct role' do
    @i.send(:role).should == role
  end
end

