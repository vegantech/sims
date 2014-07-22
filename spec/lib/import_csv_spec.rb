require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImportCSV do

  describe 'doc' do
    before :all do
        @files=ImportCSV.importers.collect(&:file_name)
        @append_files = ImportCSV.importers.select(&:supports_append?).collect(&:file_name_with_append)
        @all_files = @files + @append_files
    end

      it 'each should have a file_name assigned' do
        @files.uniq.size.should == @files.size
      end

      it 'each should have a csv file in empty' do
        files_present = Dir.glob("public/district_upload/empty/*.csv").collect{|e| e.split("/").last }
        (@all_files - files_present).should == []
      end

      it 'each should have a csv file in sample' do
        files_present = Dir.glob("public/district_upload/sample/*.csv").collect{|e| e.split("/").last }
#        pending(" missing #{(@files - files_present).join(', ')}")
        (@all_files - files_present).should == []
      end

      it 'should have zip file containing all the empty csvs' do
        zip_files =`unzip -Z1 public/district_upload/empty/empty.zip`.split("\n")
        (@all_files - zip_files).should == []
      end
      it 'should have zip file containing all the sample csvs' do
        zip_files =`unzip -Z1 public/district_upload/sample/sample.zip`.split("\n")
        (zip_files & ['ext_test_scores_append.csv', 'ext_test_scores_appends.csv']).should_not be_empty
        (@all_files - zip_files).should == []
      end
  end
  describe 'invalid file' do
    it 'should return messages' do
      i= ImportCSV.new('invalid', District.new)
      i.import
      i.messages.should include('Unknown file invalid')
    end
  end

  describe "sorted_filenames" do
    before(:all) do
      @files =["users.csv","other_append.csv","ext_test_scores_appends.csv","students.csv", "schools.csv", "other.csv",
               "ext_test_scores.csv", "groups.csv", "system_flags.csv", "user_school_assignments.csv"]
      end

    it 'should pick out the initial files and put them in order' do
      i = ImportCSV.new '', District.new
      sorted_files = i.send(:sorted_filenames,@files)
      sorted_files[0..5].should == ['schools.csv', 'students.csv', 'users.csv', 'groups.csv','system_flags.csv', 'user_school_assignments.csv']
      sorted_files = i.send(:sorted_filenames,@files.reverse)
      sorted_files[0..5].should == ['schools.csv', 'students.csv', 'users.csv', 'groups.csv','system_flags.csv', 'user_school_assignments.csv']
    end

    it 'should put the appends right after the nonappended file and other appends at the end' do
      files = @files + ["schools_append.csv" , "schools_appends.csv"]
      i = ImportCSV.new '', District.new
      sorted_files = i.send(:sorted_filenames,files)
      sorted_files[-2..-1].sort.should == ['ext_test_scores_appends.csv', 'other_append.csv']
      sorted_files[0..2].sort.should == ["schools.csv", "schools_append.csv","schools_appends.csv"]
      sorted_files = i.send(:sorted_filenames,files.reverse)
      sorted_files[-2..-1].sort.should == ['ext_test_scores_appends.csv', 'other_append.csv']
      sorted_files[0..2].sort.should == ["schools.csv", "schools_append.csv","schools_appends.csv"]

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
      i = ImportCSV.new("users_append.csv", District.new)
      i.should_receive("csv_importer").with("users_append.csv")
      i.send :process_file, "users_append.csv"
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
      CSVImporter::Users.should_receive(:new).with("users.csv",d).and_return(mock(import: nil))
      i.send :csv_importer, "users.csv"
    end

    it "should call the csv importer when the filename does contain _appends" do
      i = ImportCSV.new("ext_test_scores_appends.csv", d=District.new)
      CSVImporter::ExtTestScores.should_receive(:new).with("ext_test_scores_appends.csv",d).and_return(mock(import: nil))
      i.send :csv_importer, "ext_test_scores_appends.csv"
      CSVImporter::ExtTestScores.should_receive(:new).with("ext_test_scores_append.csv",d).and_return(mock(import: nil))
      i.send :csv_importer, "ext_test_scores_append.csv"

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

