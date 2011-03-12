require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CSVImporter::AllStudentsInDistricts do
  describe "importer"  do
    it 'should work properly' do
      District.delete_all
      User.delete_all
      SpecialUserGroup.delete_all
      @no_role_or_district_user_id = Factory(:user)
      @district = @no_role_or_district_user_id.district
      @role_no_district_user_id = Factory(:user,:district_id => @district.id)
      @should_lose_role = Factory(:user,:district_id => @district.id,  :district_user_id => 'should_lose_role')
      @should_keep_role = Factory(:user,:district_id => @district.id,  :district_user_id => 'should_keep_role')
      @should_keep_no_role = Factory(:user,:district_id => @district.id, :district_user_id => 'should_keep_no_role')
      @should_gain_role = Factory(:user,:district_id => @district.id, :district_user_id => 'should_gain_role')
      @dup_person_id = Factory(:user,:district_id => @district.id, :district_user_id => @should_gain_role.district_user_id)
      @dup_person_id.special_user_groups.create!(:district_id => @district.id, :grouptype => SpecialUserGroup::ALL_SCHOOLS_IN_DISTRICT)
      [@role_no_district_user_id, @should_lose_role, @should_keep_role].each do |u|
        u.special_user_groups.create!(:district_id => @district.id, :grouptype => SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT)
      end

      @district.users.update_all("updated_at = '2000-01-01'")
      @i=CSVImporter::AllStudentsInDistricts.new "#{Rails.root}/spec/csv/roles_base.csv",@district
      @i.import


      @no_role_or_district_user_id.reload.special_user_groups.should == []
      @should_lose_role.reload.special_user_groups == []
      @should_keep_no_role.special_user_groups.should == []

      [@role_no_district_user_id,@should_keep_role,@should_gain_role].each{|u| check_special_user_groups u}
      @dup_person_id.reload.special_user_groups.size.should == 2
      @dup_person_id.reload.special_user_groups.find_all_by_grouptype(SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT).size.should == 1
      @dup_person_id.reload.special_user_groups.find_all_by_grouptype(SpecialUserGroup::ALL_SCHOOLS_IN_DISTRICT).size.should == 1

    end

    def check_special_user_groups u
      u.reload.special_user_groups.size.should == 1
      u.reload.special_user_groups.first.grouptype.should == SpecialUserGroup::ALL_STUDENTS_IN_DISTRICT

    end

  end
end




