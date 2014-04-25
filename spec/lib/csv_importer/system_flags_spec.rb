require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

describe CSVImporter::SystemFlags do
  it_should_behave_like "csv importer"
  describe "importer"  do
    it 'should work properly' do
      #unlinked school, unlinked group, unlinked user
      Student.delete_all
      SystemFlag.delete_all
      District.delete_all


      @other_district = Factory(:district)
      @other_lose_flags = Factory(:student, district_id: @other_district.id, district_student_id: 'lose')
      @other_new_flags = Factory(:student, district_id: @other_district.id, district_student_id: 'new_flag')
      @other_lose_flags.system_flags.create!(category: 'math', reason: 'lose this one in another district')

      @district = Factory(:district)
      @unlinked_student = Factory(:student, district_id: @district.id)
      @keep_flags = Factory(:student, district_id: @district.id, district_student_id: 'keep')
      @lose_flags = Factory(:student, district_id: @district.id, district_student_id: 'lose')
      @new_flags = Factory(:student, district_id: @district.id, district_student_id: 'new_flag')

      @unlinked_student.system_flags.create!(category: 'languagearts', reason: 'this student is not linked so the flag should stay')
      @keep_flags.ignore_flags.create!(category: 'gifted', reason: 'ignore this')
      @keep_flags.custom_flags.create!(category: 'science', reason: 'ignore this')
      @keep_flags.system_flags.create!(category: 'math', reason: 'testing math')
                                             

      @lose_flags.system_flags.create!(category: 'math', reason: 'lose this one')

      @i = CSVImporter::SystemFlags.new "#{Rails.root}/spec/csv/system_flags.csv",@district
      @i.import
      @i.messages.should include("Unknown Categories for keep,invalid,'invalid flag category'")

      @unlinked_student.should have(1).system_flags

      @keep_flags.should have(1).system_flags
      @keep_flags.should have(3).flags

      @lose_flags.reload.should have(0).system_flags

      @new_flags.should have(1).system_flags

      @other_new_flags.reload.should have(0).system_flags
      @other_lose_flags.reload.should have(1).system_flags
    end

  end
end




