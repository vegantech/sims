require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/roles_base.rb')

describe CSVImporter::DistrictAdmins do
  it_should_behave_like "role importer"

  def myclass
    CSVImporter::DistrictAdmins
  end

  def role
    "local_system_administrator"
  end

  it 'should have the correct role' do
    @i.send(:role).should == role
  end
end

