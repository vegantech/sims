require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/roles_base.rb')

describe CSVImporter::RegularUsers do
  include_context "role importer"

  def myclass
    CSVImporter::RegularUsers
  end

  def role
    "regular_user"
  end

  it 'should have the correct role' do
    @i.send(:role).should == role
  end
end

