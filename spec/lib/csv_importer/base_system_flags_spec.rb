require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

describe CSVImporter::BaseSystemFlags do
  it_should_behave_like "csv importer"
  describe "importer"  do
    it 'should work properly for math' do
      # unlinked school, unlinked group, unlinked user
      Student.delete_all
      SystemFlag.delete_all
      District.delete_all

      @district = Factory(:district)
      @other_district = Factory(:district)
      @other_lose_flags = Factory(:student, district_id: @other_district.id, district_student_id: 'lose')
      @other_new_flags = Factory(:student, district_id: @other_district.id, district_student_id: 'new_flag')
      @other_lose_flags.system_flags.create!(category: 'math', reason: 'lose this one in another district')
      
      

      @unlinked_student = Factory(:student, district_id: @district.id)
      @keep_flags = Factory(:student, district_id: @district.id, district_student_id: 'keep')
      @lose_flags = Factory(:student, district_id: @district.id, district_student_id: 'lose')
      @new_flags = Factory(:student, district_id: @district.id, district_student_id: 'new_flag')

      @unlinked_student.system_flags.create!(category: 'math', reason: 'this student is not linked so the flag should stay')
      @new_flags.ignore_flags.create!(category: 'math', reason: 'ignore this')
      @keep_flags.custom_flags.create!(category: 'math', reason: 'ignore this')
      @keep_flags.system_flags.create!(category: 'math', reason: 'testing math')
                                            
      @keep_flags.system_flags.create!(category: 'gifted',reason: 'this should not be touched')

      @lose_flags.system_flags.create!(category: 'math', reason: 'lose this one')

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
end




