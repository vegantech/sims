require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

describe CSVImporter::UserSchoolAssignments do
  it_should_behave_like "csv importer"
  describe "importer"  do
    it 'should work properly' do
      #be sure to test with existing admin
      School.delete_all
      UserSchoolAssignment.delete_all
      District.delete_all
      User.delete_all

      @no_role_or_district_user_id = Factory(:user)
      @district = @no_role_or_district_user_id.district
      @school_no_link = Factory(:school, :district_id => @district.id)
      @school_with_link = Factory(:school, :district_id => @district.id, :district_school_id => 2)
      @school_with_link_admin = Factory(:user, :district_id => @district.id, :district_user_id => 'school_with_link_admin')
      @school_with_link_admin.user_school_assignments.create!(:school_id => @school_with_link.id, :admin => true) 
      @school_with_link_admin2 = Factory(:user, :district_id => @district.id, :district_user_id => 'school_with_link_admin2')
      @school_with_link_admin2.user_school_assignments.create!(:school_id => @school_with_link.id, :admin => true) 
      
      @no_role_or_district_user_id.user_school_assignments.create!(:school_id => @school_no_link.id)
      
      
      @role_no_district_user_id = Factory(:user,:district_id => @district.id)
      @should_lose_role = Factory(:user,:district_id => @district.id,  :district_user_id => 'should_lose_role')
      @should_keep_role = Factory(:user,:district_id => @district.id,  :district_user_id => 'should_keep_role')
      @should_keep_no_role = Factory(:user,:district_id => @district.id, :district_user_id => 'should_keep_no_role')
      @should_gain_role = Factory(:user,:district_id => @district.id, :district_user_id => 'should_gain_role')
      @dup_person_id = Factory(:user,:district_id => @district.id, :district_user_id => @should_gain_role.district_user_id)
      @dup_person_id.user_school_assignments.create!(:school_id => @school_no_link.id)
      [@role_no_district_user_id, @should_lose_role, @should_keep_role].each do |u|
        u.user_school_assignments.create!(:school_id => @school_with_link.id)
      end


      @role_no_district_user_id.user_school_assignments.create!(:school_id => @school_no_link.id)
      @district.users.update_all("updated_at = '2000-01-01'")
      @i=CSVImporter::UserSchoolAssignments.new "#{Rails.root}/spec/csv/user_school_assignments.csv",@district
      @i.import

      @school_with_link_admin.reload.user_school_assignments.collect(&:admin).should == [true]
      @school_with_link_admin2.reload.user_school_assignments.collect(&:admin).should == [true]


      @no_role_or_district_user_id.reload.user_school_assignments.size.should == 1
      @no_role_or_district_user_id.user_school_assignments.find_all_by_school_id(@school_no_link.id).size.should == 1

      @should_lose_role.reload.user_school_assignments == []
      @should_keep_no_role.user_school_assignments.should == []

      [@should_keep_role,@should_gain_role].each{|u| check_user_school_assignments u}
      @dup_person_id.reload.user_school_assignments.count.should == 2

      @dup_person_id.schools.should =~ [@school_no_link, @school_with_link]
      @dup_person_id.user_school_assignments.collect(&:school_id).to_set.should == [@school_no_link.id, @school_with_link.id].to_set
      
      @role_no_district_user_id.schools.should =~ [@school_no_link, @school_with_link]
      @role_no_district_user_id.user_school_assignments.collect(&:school_id).should =~ [@school_no_link.id, @school_with_link.id]
    end

    def check_user_school_assignments u
      u.reload.user_school_assignments.size.should == 1
      u.user_school_assignments.find_all_by_school_id(@school_with_link).size.should == 1
    end

  end
end




