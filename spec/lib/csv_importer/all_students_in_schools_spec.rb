require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CSVImporter::AllStudentsInSchools do
  describe "importer"  do
    it 'should work properly' do
      School.delete_all
      UserSchoolAssignment.delete_all
      District.delete_all
      User.delete_all
      SpecialUserGroup.delete_all

      @no_role_or_district_user_id = Factory(:user)
      @district = @no_role_or_district_user_id.district
      @school_no_link = Factory(:school, :district_id => @district.id)
      @school_with_link = Factory(:school, :district_id => @district.id, :district_school_id => 'linked_school')
      
      @no_role_or_district_user_id.special_user_groups.create!(:district_id => @district.id, :grouptype => SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL, :school_id => @school_no_link.id)
      @no_role_or_district_user_id.special_user_groups.create!(:district_id => @district.id, :grouptype => SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL, :school_id => @school_no_link.id, :grade=>'02')
      
      @role_no_district_user_id = Factory(:user,:district_id => @district.id)
      @should_lose_role = Factory(:user,:district_id => @district.id,  :district_user_id => 'should_lose_role')
      @should_keep_role = Factory(:user,:district_id => @district.id,  :district_user_id => 'should_keep_role')
      @should_keep_no_role = Factory(:user,:district_id => @district.id, :district_user_id => 'should_keep_no_role')
      @should_gain_role = Factory(:user,:district_id => @district.id, :district_user_id => 'should_gain_role')
      @dup_person_id = Factory(:user,:district_id => @district.id, :district_user_id => @should_gain_role.district_user_id)
      @dup_person_id.special_user_groups.create!(:district_id => @district.id, :grouptype => SpecialUserGroup::ALL_SCHOOLS_IN_DISTRICT)
      @dup_person_id.special_user_groups.create!(:district_id => @district.id, :grouptype => SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL, :school_id => @school_no_link.id)
      [@role_no_district_user_id, @should_lose_role, @should_keep_role].each do |u|
        u.special_user_groups.create!(:district_id => @district.id, :grouptype => SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL, :school_id => @school_with_link.id)
      end


      @role_no_district_user_id.special_user_groups.create!(:district_id => @district.id, :grouptype => SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL, :school_id => @school_no_link.id)
      @district.users.update_all("updated_at = '2000-01-01'")
      @i=CSVImporter::AllStudentsInSchools.new "#{Rails.root}/spec/csv/all_students_in_schools.csv",@district
      @i.import


      @no_role_or_district_user_id.reload.special_user_groups.size.should == 2
      @no_role_or_district_user_id.user_school_assignments.find_all_by_school_id(@school_no_link.id).size.should == 1

      @should_lose_role.reload.special_user_groups == []
      @should_keep_no_role.special_user_groups.should == []

      [@should_keep_role,@should_gain_role].each{|u| check_special_user_groups u}
      @dup_person_id.reload.special_user_groups.size.should == 3
      @dup_person_id.reload.special_user_groups.find_all_by_grouptype(SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL).size.should == 2
      @dup_person_id.reload.special_user_groups.find_all_by_grouptype(SpecialUserGroup::ALL_SCHOOLS_IN_DISTRICT).size.should == 1
      @dup_person_id.reload.user_school_assignments.count.should == 2

      @dup_person_id.school_ids.to_set.should == [@school_no_link.id, @school_with_link.id].to_set
      @dup_person_id.special_user_groups.find_all_by_grouptype(SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL).collect(&:school_id).to_set.should == [@school_no_link.id, @school_with_link.id].to_set
      
      @role_no_district_user_id.school_ids.to_set.should == [@school_no_link.id, @school_with_link.id].to_set
      @role_no_district_user_id.special_user_groups.find_all_by_grouptype(SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL).collect(&:school_id).to_set.should == [@school_no_link.id, @school_with_link.id].to_set
    end

    def check_special_user_groups u
      u.reload.special_user_groups.size.should == 1
      u.reload.special_user_groups.first.grouptype.should == SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL
      u.user_school_assignments.find_all_by_school_id(@school_with_link).size.should == 1

    end

  end
end




