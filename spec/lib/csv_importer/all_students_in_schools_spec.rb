require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

describe CSVImporter::AllStudentsInSchools do
  it_should_behave_like "csv importer"
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
      @school_with_link = Factory(:school, :district_id => @district.id, :district_school_id => 2)
      @no_role_or_district_user_id.special_user_groups.create!(:school_id => @school_no_link.id)
      @no_role_or_district_user_id.special_user_groups.create!(:school_id => @school_no_link.id, :grade=>'02')
      @role_no_district_user_id = Factory(:user,:district_id => @district.id)
      @should_lose_role = Factory(:user,:district_id => @district.id,  :district_user_id => 'should_lose_role')
      @should_keep_role = Factory(:user,:district_id => @district.id,  :district_user_id => 'should_keep_role')
      @should_keep_no_role = Factory(:user,:district_id => @district.id, :district_user_id => 'should_keep_no_role')
      @should_gain_role = Factory(:user,:district_id => @district.id, :district_user_id => 'should_gain_role')
      @dup_person_id = Factory(:user,:district_id => @district.id, :district_user_id => @should_gain_role.district_user_id)
      @dup_person_id.update_attribute(:all_students,true)
      @dup_person_id.special_user_groups.create!(:school_id => @school_no_link.id)
      @user_and_principal = Factory(:user, :district_id => @district.id, :district_user_id => 'user_and_principal')
      [@role_no_district_user_id, @should_lose_role, @should_keep_role].each do |u|
        u.special_user_groups.create!(:school_id => @school_with_link.id)
      end


      @role_no_district_user_id.special_user_groups.create!(:school_id => @school_no_link.id)
      @district.users.update_all("updated_at = '2000-01-01'")
      @i=CSVImporter::AllStudentsInSchools.new "#{Rails.root}/spec/csv/all_students_in_schools.csv",@district
      @i.import

      @i.messages.should include("8 Users automatically assigned to a school")


      @no_role_or_district_user_id.reload.special_user_groups.size.should == 2
      @no_role_or_district_user_id.user_school_assignments.find_all_by_school_id(@school_no_link.id).size.should == 1

      @should_lose_role.reload.special_user_groups == []
      @should_keep_no_role.special_user_groups.should == []

      [@should_keep_role,@should_gain_role].each{|u| check_special_user_groups u}
      @dup_person_id.reload.special_user_groups.size.should == 2
      @dup_person_id.reload.all_students.should be
      @dup_person_id.reload.user_school_assignments.count.should == 2

      @dup_person_id.user_school_assignments.collect(&:school_id).should =~ [@school_no_link.id, @school_with_link.id]
      @dup_person_id.special_user_groups.collect(&:school_id).should =~ [@school_no_link.id, @school_with_link.id]

      @role_no_district_user_id.reload.user_school_assignments.collect(&:school_id).should =~ [@school_no_link.id, @school_with_link.id]
      @role_no_district_user_id.special_user_groups.collect(&:school_id).should =~ [@school_no_link.id, @school_with_link.id]
      @user_and_principal.special_user_groups.principal.count.should == 1
      @user_and_principal.special_user_groups.count.should == 2
    end

    def check_special_user_groups u
      u.reload.special_user_groups.size.should == 1
      u.user_school_assignments.find_all_by_school_id(@school_with_link).size.should == 1
    end

  end
end




