require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

describe CSVImporter::ExtTestScores do
  it_should_behave_like "csv importer"
  before do
    District.delete_all
    Student.delete_all
    ExtTestScore.delete_all
    @district = Factory(:district)
    @district2 = Factory(:district)
    @d2s2=@district2.students.create!(:id_state=>3, :first_name => 'second', :last_name => 'student', :district_student_id => 's2')
    @s1=@district.students.create!(:id_state=>1, :first_name => 'first', :last_name => 'student', :district_student_id => 's1')
    @s2=@district.students.create!(:id_state=>2, :first_name => 'second', :last_name => 'student', :district_student_id => 's2')
    @s1.ext_test_scores.create!(:name => 'Update 1' , :date => '2011-01-01', :enddate => nil, :result => '1', :scaleScore => 2)
    @s1.ext_test_scores.create!(:name => 'Update 2' , :date => '2011-01-01', :enddate => '2011-02-02', :result => '1', :scaleScore => 2)
    @s1.ext_test_scores.create!(:name => 'Update 3' , :date => '2011-01-01', :enddate => '2011-02-02', :result => '1', :scaleScore => 2)
    @s1.ext_test_scores.create!(:name => 'Not in csv' , :date => '2011-01-01', :enddate => '2011-02-02', :result => '1', :scaleScore => 2)
    @s2.ext_test_scores.create!(:name => 'Update 1' , :date => '2011-01-01', :enddate => nil, :result => '1', :scaleScore => 2)
    @d2s2.ext_test_scores.create!(:name => 'Update 1' , :date => '2011-01-01', :enddate => nil, :result => '1', :scaleScore => 2)
    @ext_test_scores = ExtTestScore.all

  end

  def append_file
    File.join Rails.root, "spec", "csv", "ext_test_scores_appends.csv"

  end

  def file
    File.join Rails.root, "spec", "csv", "ext_test_scores.csv"
  end

  describe "without append" do
    it 'should clear everything out and replace ext test scores with what is in the file' do
      @i=CSVImporter::ExtTestScores.new file,@district
      @i.import
      @s2.reload.should have(0).ext_test_scores
      @s1.reload.should have(4).ext_test_scores
      @s1.ext_test_scores.find_by_name('Append 1').should be_present
      @s1.ext_test_scores.find_by_name('Not in csv').should be_blank
    end

    it 'should not affect anything in other districts' do
      old_d2s2_ext_test_scores = @d2s2.ext_test_scores.collect(&:attributes)
      @i=CSVImporter::ExtTestScores.new file,@district
      @i.import
      old_d2s2_ext_test_scores.should == @d2s2.reload.ext_test_scores.collect(&:attributes)
    end

  end

  describe "with append" do
    it 'should have append_file_name' do
      CSVImporter::ExtTestScores.file_name_with_append.should == "ext_test_scores_append.csv"

    end
    it 'should fail with a message when there are duplicates' do
        @i=CSVImporter::ExtTestScores.new append_file,@district
        @i.import
      #pending do
        @s2.reload.should have(1).ext_test_scores
        @s1.reload.should have(4).ext_test_scores
        @i.messages.should include("There were duplicates, remove them or upload all scores without appends")
      #end

    end

    it 'should append all scores when there are no duplicates' do
      ExtTestScore.update_all("name = concat(name,'1')")
      @i=CSVImporter::ExtTestScores.new append_file,@district
      @i.import
      @s1.reload.should have(8).ext_test_scores
    end
  end

=begin
  describe 'insert' do
    it 'should append append1 and leave everything else unchanged' do
      old= ExtTestScore.all
      insert_count = @i.send(:insert)
      @s2.reload.should have(1).ext_test_scores
      @s1.reload.should have(5).ext_test_scores
      insert_count.should == 1
      ExtTestScore.all.collect(&:attributes).should == @ext_test_scores.collect(&:attributes) | [ExtTestScore.last.attributes]
    end
  end

  describe 'update' do
    it 'should work' do
      @i.send(:update).should == 3
      #      ExtTestScore.all.collect(&:attributes).should == @ext_test_scores.collect(&:attributes) | [ExtTestScore.last.attributes]
    end
  end

  describe 'delete' do
    it 'should do nothing' do
      del_count =  @i.send :delete
      del_count.should be_nil
      @ext_test_scores.collect(&:attributes).should == ExtTestScore.all.collect(&:attributes)
    end
  end
=end
end

