require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

describe CSVImporter::Base do
  describe 'append_failure?' do
    it 'should fail with a message when it does not support append' do
      c=CSVImporter::Base.new("test_appends.csv",District.new)
      c.send(:append_failure?).should be_true
      c.messages.should include("Append is not supported for bases.csv")
    end
    it 'should not fail with a message when it does not support append and the file doesnt include it' do
      c=CSVImporter::Base.new("test.csv",District.new)
      c.send(:append_failure?).should be_false
    end
    it 'should return false with no message when it does support append and the filename has it' do
      c=CSVImporter::Base.new("test_appends.csv",District.new)
      klass=c.class
      def klass.supports_append?
        true
      end
      c.send(:append_failure?).should be_false
      c.messages.should_not include("Append is not supported for bases.csv")
      def klass.supports_append?
        false
      end
    end
    it 'should return false when append is supported but not requested' do
      c=CSVImporter::Base.new("test",District.new)
      c.send(:append_failure?).should be_false
    end
  end
=begin
  describe "importer"  do
    it 'should work properly for math' do
      #unlinked school, unlinked group, unlinked user
      Student.delete_all
      SystemFlag.delete_all
      District.delete_all


      @district = Factory(:district)
      @other_district = Factory(:district)
      @other_lose_flags = Factory(:student, :district_id => @other_district.id, :district_student_id => 'lose')
      @other_new_flags = Factory(:student, :district_id => @other_district.id, :district_student_id => 'new_flag')
      @other_lose_flags.system_flags.create!(:category=>'math', :reason => 'lose this one in another district')


      @unlinked_student = Factory(:student, :district_id => @district.id)
      @keep_flags = Factory(:student, :district_id => @district.id, :district_student_id => 'keep')
      @lose_flags = Factory(:student, :district_id => @district.id, :district_student_id => 'lose')
      @new_flags = Factory(:student, :district_id => @district.id, :district_student_id => 'new_flag')

      @unlinked_student.system_flags.create!(:category=>'math', :reason => 'this student is not linked so the flag should stay')
      @new_flags.ignore_flags.create!(:category=>'math', :reason => 'ignore this')
      @keep_flags.custom_flags.create!(:category=>'math', :reason => 'ignore this')
      @keep_flags.system_flags.create!(:category=>'math', :reason => 'testing math')
      @keep_flags.system_flags.create!(:category=>'gifted',:reason => 'this should not be touched')

      @lose_flags.system_flags.create!(:category=>'math', :reason => 'lose this one')

      @i=CSVImporter::MathSystemFlags.new "#{Rails.root}/spec/csv/base_system_flags.csv",@district
      @i.import

      @unlinked_student.should have(1).system_flags

      @keep_flags.should have(2).system_flags
      @keep_flags.should have(3).flags

      @lose_flags.reload.should have(0).system_flags

      @new_flags.should have(1).system_flags
      @new_flags.should have(1).ignore_flags

      @other_new_flags.reload.should have(0).system_flags
      @other_lose_flags.reload.should have(1).system_flags

    end

  end
=end
end




