require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CSVImporter::Students do
  describe 'reject_students_with_nil_data_but_nonmatching_birthdate_or_last_name_if_birthdate_is_nil_on_one_side' do
    it 'should reject students with matching id state but nonmatching birthdate or name' do
      District.delete_all
      Student.delete_all
      d=Factory(:district)
      d.students.create!(:id_state => 99, :first_name => "MISMATCHED", :last_name => "NAME_BUT_MATCHED_BIRTHDATE", :birthdate => "2006-01-01")
      d.students.create!(:id_state => 98, :first_name => "NULL_BIRTHDATE_IN_DB", :last_name => "MATCHING_NAME", :birthdate => nil)
      d.students.create!(:id_state => 97, :first_name => "NONMATCHING_BIRTHDATE_IN_DB", :last_name => "MATCHED_NAME", :birthdate => '2006-01-02')
      d.students.create!(:id_state => 96, :first_name => "NULL_BIRTHDATE_IN_DB", :last_name => "MISMATCHED_NAME", :birthdate =>nil )
      Student.update_all("district_id = null")
      file_name = ''
      i=CSVImporter::Students.new file_name,d
      i.send(:create_temporary_table)
      ActiveRecord::Base.connection.execute("Insert into #{i.send(:temporary_table_name)}
                                            (#{i.send(:csv_headers).collect(&:to_s).join(",")})
                                            values
                                            (99, -1,-1, 'MATCHING_BIRTHDATE',NULL, 'MISMATCHED_NAME', NULL, '2006-01-01', FALSE, FALSE),
                                            (98, -1,-1, 'NULL_BIRTHDATE_IN_DB',NULL, 'MATCHING_NAME', NULL, '2006-01-01', FALSE, FALSE),
                                            (97, -1,-1, 'NON_MATCHING_BIRTHDATE',NULL, 'MATCHED_NAME', NULL, '2006-01-01', FALSE, FALSE),
                                            (96, -1,-1, 'NULL_BIRTHDATE',NULL, 'MISMATCHED_NAME2', NULL, '2006-01-01', FALSE, FALSE)
                                            
                                            ")

      i.send :reject_students_with_nil_data_but_nonmatching_birthdate_or_last_name_if_birthdate_is_nil_on_one_side                                      
     i.send(:drop_temporary_table)
      

      i.messages.sort.should == ["Student with matching id_state: 96, NULL_BIRTHDATE MISMATCHED_NAME2 could be claimed but does not appear to be the same student.  Please make sure the id_state is correct for this student, and if so contact the state administrator.", 
        "Student with matching id_state: 97, NON_MATCHING_BIRTHDATE MATCHED_NAME could be claimed but does not appear to be the same student.  Please make sure the id_state is correct for this student, and if so contact the state administrator."]


    end
  end

end

