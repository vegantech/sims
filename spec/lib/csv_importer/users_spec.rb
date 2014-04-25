require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

describe CSVImporter::Users do
  it_should_behave_like "csv importer"
  describe 'optional headers' do
    it 'should allow the optional headers to be missing' do
      District.delete_all
      User.delete_all
      d = Factory(:district)
      i = CSVImporter::Users.new Rails.root.join("spec","csv","users", "optional_fields_missing", "users.csv").to_s,d
      i.import
      User.count.should == 2
    end
  end
end

