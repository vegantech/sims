require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImportCSV do

  describe 'doc' do
    before :all do
        @files=ImportCSV.importers.collect(&:file_name)
    end

      it 'each should have a file_name assigned' do
        @files.uniq.size.should == @files.size
      end

      it 'each should have a csv file in empty' do
        files_present = Dir.glob("public/district_upload/empty/*.csv").collect{|e| e.split("/").last }
        (@files - files_present).should == []
      end

      it 'each should have a csv file in sample' do
        files_present = Dir.glob("public/district_upload/sample/*.csv").collect{|e| e.split("/").last }
#        pending(" missing #{(@files - files_present).join(', ')}")
        (@files - files_present).should == []
      end

      it 'should have zip file containing all the empty csvs' do
        zip_files =`unzip -Z1 public/district_upload/empty/empty.zip`.split("\n")
        (@files - zip_files).should == []
      end
      it 'should have zip file containing all the sample csvs' do
        zip_files =`unzip -Z1 public/district_upload/sample/sample.zip`.split("\n")
#        pending
        (@files - zip_files).should == []
      end
  end
  describe 'invalid file' do
    it 'should return messages' do
      i= ImportCSV.new('invalid', District.new)
      i.import
      i.messages.should include('Unknown file invalid')
    end

  end

  describe "process_file" do
    it 'should call the csv importer with the filename if it is a known importer' do
      i = ImportCSV.new("users.csv", District.new)
      i.should_receive("csv_importer").with("users.csv")
      i.send :process_file, "users.csv"
    end
    it 'should call the csv importer with the filename if it is a known importer ending in appends' do
      i = ImportCSV.new("users_appends.csv", District.new)
      i.should_receive("csv_importer").with("users_appends.csv")
      i.send :process_file, "users_appends.csv"
    end

    it 'should return an error if the importer/filename is unknown' do
      i = ImportCSV.new("users.csv", District.new)
      i.should_not_receive("csv_importer").with("users.csv")
      i.send :process_file, "users_invalid.csv"
    end

    it 'should return an error fi the importer/filename is unknown and the filename ends in appends' do
      i = ImportCSV.new("users.csv", District.new)
      i.should_not_receive("csv_importer")
      i.send :process_file, "users_invalid_appends.csv"
      i.send :process_file, "users_invalid_append.csv"
    end
  end

  describe "csv_importer" do
    it "should call the csv importer when the filename does not contain _appends"  do
      i = ImportCSV.new("users.csv", d=District.new)
      CSVImporter::Users.should_receive(:new).with("users.csv",d).and_return(mock_object(:import => nil))
      i.send :csv_importer, "users.csv"
    end

    it "should call the csv importer when the filename does contain _appends" do
      i = ImportCSV.new("users.csv", d=District.new)
      CSVImporter::Users.should_receive(:new).with("users_appends.csv",d).and_return(mock_object(:import => nil))
      i.send :csv_importer, "users_appends.csv"
      CSVImporter::Users.should_receive(:new).with("users_append.csv",d).and_return(mock_object(:import => nil))
      i.send :csv_importer, "users_append.csv"

    end


  end

  describe 'sort_files' do
    # ['schools.csv', 'students.csv', 'users.csv']
    it 'should sort with the required files first' do
      i=ImportCSV.new '', District.new
      i.send(:sorted_filenames, ['dog.csv', 'users.csv','schools.csv']).should == ['schools.csv', 'users.csv', 'dog.csv']
      i.send(:sorted_filenames, ['/tmp/Dog.csv', '/a/users.csv','/b/SChOOls.csv']).should == ['/b/SChOOls.csv', '/a/users.csv', '/tmp/Dog.csv']
    end
  end


end

