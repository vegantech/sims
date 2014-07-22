require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

describe CSVImporter::AllStudentsInSchools do
  it_should_behave_like "csv importer"
  describe "importer"  do
    it 'should work properly' do
      #be sure to test with existing admin
      School.delete_all
      StaffAssignment.delete_all
      District.delete_all
      User.delete_all

      @no_role_or_district_user_id = Factory(:user)
      @district = @no_role_or_district_user_id.district
      @school_no_link = Factory(:school, district_id: @district.id)
      @school_with_link = Factory(:school, district_id: @district.id, district_school_id: 2)
      
      @no_role_or_district_user_id.staff_assignments.create!(school_id: @school_no_link.id)
      
      
      @role_no_district_user_id = Factory(:user,district_id: @district.id)
      @should_lose_role = Factory(:user,district_id: @district.id,  district_user_id: 'should_lose_role')
      @should_keep_role = Factory(:user,district_id: @district.id,  district_user_id: 'should_keep_role')
      @should_keep_no_role = Factory(:user,district_id: @district.id, district_user_id: 'should_keep_no_role')
      @should_gain_role = Factory(:user,district_id: @district.id, district_user_id: 'should_gain_role')
      @dup_person_id = Factory(:user,district_id: @district.id, district_user_id: @should_gain_role.district_user_id)
      @dup_person_id.staff_assignments.create!(school_id: @school_no_link.id)
      [@role_no_district_user_id, @should_lose_role, @should_keep_role].each do |u|
        u.staff_assignments.create!(school_id: @school_with_link.id)
      end

      @role_no_district_user_id.staff_assignments.create!(school_id: @school_no_link.id)
      @district.users.update_all("updated_at = '2000-01-01'")
      @i=CSVImporter::StaffAssignments.new "#{Rails.root}/spec/csv/staff_assignments.csv",@district
      @i.import

      @no_role_or_district_user_id.reload.staff_assignments.size.should == 1
      @no_role_or_district_user_id.staff_assignments.find_all_by_school_id(@school_no_link.id).size.should == 1

      @should_lose_role.reload.staff_assignments == []
      @should_keep_no_role.staff_assignments.should == []

      [@should_keep_role,@should_gain_role].each{|u| check_staff_assignments u}
      @dup_person_id.reload.staff_assignments.count.should == 2

      @dup_person_id.staff_assignments.collect(&:school_id).to_set.should == [@school_no_link.id, @school_with_link.id].to_set
      @dup_person_id.staff_assignments.collect(&:school_id).to_set.should == [@school_no_link.id, @school_with_link.id].to_set
      
      @role_no_district_user_id.staff_assignments.collect(&:school_id).to_set.should == [@school_no_link.id, @school_with_link.id].to_set
      @role_no_district_user_id.staff_assignments.collect(&:school_id).to_set.should == [@school_no_link.id, @school_with_link.id].to_set
    end

    def check_staff_assignments u
      u.reload.staff_assignments.size.should == 1
      u.staff_assignments.find_all_by_school_id(@school_with_link).size.should == 1
    end

  end
end




