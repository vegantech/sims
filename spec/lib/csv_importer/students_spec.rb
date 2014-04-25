require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

describe CSVImporter::Students do
  it_should_behave_like "csv importer"
  describe 'make sure esl and special_ed are correct' do
    it 'should upload properly' do
      District.delete_all
      Student.delete_all
      d = Factory(:district)
      i = CSVImporter::Students.new "#{Rails.root}/spec/csv/students.csv",d
      i.import
      expected = {997 => [false,true], 992 => [false,false], 993 => [false, false],
                  994 => [false,false], 995 => [false,false], 996 => [false,false],
                  998 => [true, true], 999 => [true,true],
                  1000 => [false, false], 1001 => [true,false], 1002 => [true,false]
        }


      Student.find_all_by_id_state(expected.keys).each do |student|
        esl = expected[student[:id_state].to_i][0]
        spec_ed = expected[student[:id_state].to_i][1]
        student.esl.should be(esl)
        student.special_ed.should be(spec_ed)
      end


    end

  end


  describe 'delete' do
    it 'should remove the students from the district and clear out the enrollments' do
      District.delete_all
      Student.delete_all
      d = Factory(:district)
      s1 = d.students.create!(id_state: 1, first_name: 'keep', last_name: 'student', district_student_id: 's1')
      s1.enrollments.create(school_id: 1, grade: '01')
      s2 = d.students.create!(id_state: 2, first_name: 'destroy', last_name: 'student', district_student_id: 's2')
      s2.enrollments.create!(school_id: 1, grade: '02')
      e3 = Enrollment.create!(student_id: -1,grade: -1,school_id: -1)
      s3 = d.students.create!(id_state: nil, first_name: 'blank_district_student_id', last_name: 'student', district_student_id: '')

      file_name = ''
      i = CSVImporter::Students.new file_name,d
      i.send(:create_temporary_table)
      ActiveRecord::Base.connection.execute("Insert into #{i.send(:temporary_table_name)}
                                            (#{i.send(:csv_headers).collect(&:to_s).join(",")})
                                            values
                                            (1, 's1',-1, 'keep',NULL, 'student', NULL, '2006-01-01', FALSE, FALSE)
                                            ")

     del_count =  i.send :delete
     i.send(:drop_temporary_table)

     i.instance_variable_get('@other_messages').should == "1 students removed from district; "
     s2.reload.district.should == nil
     s1.reload.district.should == d
     s1.enrollments.size.should == 1
     e3.reload.grade.should == '-1'
     s2.enrollments.should be_empty

    end
  end



  describe 'reject_students_with_nil_data_but_nonmatching_birthdate_or_last_name_if_birthdate_is_nil_on_one_side' do
    it 'should reject students with matching id state but nonmatching birthdate or name' do
      District.delete_all
      Student.delete_all
      d = Factory(:district)
      d.students.create!(id_state: 99, first_name: "MISMATCHED", last_name: "NAME_BUT_MATCHED_BIRTHDATE", birthdate: "2006-01-01")
      d.students.create!(id_state: 98, first_name: "NULL_BIRTHDATE_IN_DB", last_name: "MATCHING_NAME", birthdate: nil)
      d.students.create!(id_state: 97, first_name: "NONMATCHING_BIRTHDATE_IN_DB", last_name: "MATCHED_NAME", birthdate: '2006-01-02')
      d.students.create!(id_state: 96, first_name: "NULL_BIRTHDATE_IN_DB", last_name: "MISMATCHED_NAME", birthdate: nil )
      d.students.create!(id_state: 95, first_name: "NULL_BIRTHDATE_IN_CSV", last_name: "MATCHED_NAME", birthdate: '2006-01-04' )
      d.students.create!(id_state: 94, first_name: "NULL_BIRTHDATE_IN_DB", last_name: "mismatched_case", birthdate: nil )
      d.students.create!(id_state: 93, first_name: "NULL_BIRTHDATE_IN_CSV", last_name: "mismatched_case", birthdate: '2006-01-05' )
      d.students.create!(id_state: 92, first_name: "ZERO_BIRTHDATE_IN_DB", last_name: "mismatched_case", birthdate: '0000-00-00' )
      Student.update_all("birthdate = 0", "id_state = 92")
      Student.update_all("district_id = null")
      file_name = ''
      i = CSVImporter::Students.new file_name,d
      i.send(:create_temporary_table)
      ActiveRecord::Base.connection.execute("Insert into #{i.send(:temporary_table_name)}
                                            (#{i.send(:csv_headers).collect(&:to_s).join(",")})
                                            values
                                            (99, -1,-1, 'MATCHING_BIRTHDATE',NULL, 'MISMATCHED_NAME', NULL, '2006-01-01', FALSE, FALSE),
                                            (98, -1,-1, 'NULL_BIRTHDATE_IN_DB',NULL, 'MATCHING_NAME', NULL, '2006-01-01', FALSE, FALSE),
                                            (97, -1,-1, 'NON_MATCHING_BIRTHDATE',NULL, 'MATCHED_NAME', NULL, '2006-01-01', FALSE, FALSE),
                                            (96, -1,-1, 'NULL_BIRTHDATE',NULL, 'MISMATCHED_NAME2', NULL, '2006-01-01', FALSE, FALSE),
                                            (95, -1,-1, 'NULL_BIRTHDATE_IN_CSV',NULL, 'MATCHED_NAME', NULL, NULL, FALSE, FALSE),
                                            (94, -1,-1, 'NULL_BIRTHDATE_IN_DB',NULL, 'MISMATCHED_CASE', NULL, '2006-01-05', FALSE, FALSE),
                                            (93, -1,-1, 'NULL_BIRTHDATE_IN_CSV',NULL, 'MISMATCHED_CASE', NULL, NULL, FALSE, FALSE),
                                            (92, -1,-1, 'ZERO_BIRTHDATE_IN_DB',NULL, 'MISMATCHED_CASE', NULL, '2006-01-05', FALSE, FALSE)
                                            ")

      i.send :reject_students_with_nil_data_but_nonmatching_birthdate_or_last_name_if_birthdate_is_nil_on_one_side
     i.send(:drop_temporary_table)


      i.messages.sort.should ==
        ["Student with matching id_state: 96, NULL_BIRTHDATE MISMATCHED_NAME2 could be claimed but does not appear to be the same student.  Please make sure the id_state is correct for this student, and if so contact the state administrator.",
         "Student with matching id_state: 97, NON_MATCHING_BIRTHDATE MATCHED_NAME could be claimed but does not appear to be the same student.  Please make sure the id_state is correct for this student, and if so contact the state administrator."
      ]


    end
  end

  describe 'disallow invalid birthdates' do
   
    it 'should zero out or reject an invalid birthdate' do
      District.delete_all
      Student.delete_all
      d = Factory(:district)
      i = CSVImporter::Students.new "#{Rails.root}/spec/csv/students/invalid_birthdate/students.csv",d
      i.import
      d.students.first.birthdate.should be_nil
      d.students.last.birthdate.should be_nil
    end

  end

end

