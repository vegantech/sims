require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/import_base.rb')

shared_context "role importer"  do
  it_should_behave_like "csv importer"
  before(:all) do
    District.delete_all
    User.delete_all

    @other_role =Role::ROLES[Role::ROLES.index(role)-1]
    @other_district = Factory(:district)
    @other_user = Factory(:user, district_user_id: 'should_gain_role', district_id: @other_district.id, roles: [])
    @other_user2 = Factory(:user, district_user_id: 'should_lose_role', district_id: @other_district.id, roles: [@other_role,role])
    @other_user3 = Factory(:user, district_user_id: 'should_lose_role2', district_id: @other_district.id, roles: [role])
    @other_user2.roles.sort.should == [role,@other_role].sort
    User.update_all("updated_at = '1999-01-01'")

    @no_role_or_district_user_id = Factory(:user)
    @district = @no_role_or_district_user_id.district
    @role_no_district_user_id = Factory(:user,district_id: @district.id, roles: [role])
    @should_lose_role = Factory(:user,district_id: @district.id, roles: [role,@other_role], district_user_id: 'should_lose_role')
    @should_keep_role = Factory(:user,district_id: @district.id, roles: [role,@other_role], district_user_id: 'should_keep_role')
    @should_keep_no_role = Factory(:user,district_id: @district.id, roles: [@other_role], district_user_id: 'should_keep_no_role')
    @should_gain_role = Factory(:user,district_id: @district.id, district_user_id: 'should_gain_role')
    @dup_person_id = Factory(:user,district_id: @district.id, district_user_id: @should_gain_role.district_user_id)
    @district.users.update_all("updated_at = '2000-01-01'")
    @i=myclass.new "#{Rails.root}/spec/csv/roles_base.csv",@district
    @i.import

    @no_role_or_district_user_id.reload.roles.should == []
    @role_no_district_user_id.reload.roles.should == [role]
    @should_keep_role.reload.roles.sort.should == [role,@other_role].sort
    @should_keep_role.updated_at.utc.to_date.to_s.should == "2000-01-01"
    @should_lose_role.reload.roles.should == [@other_role]
    @should_lose_role.updated_at.to_date == Date.today

    @should_keep_no_role.reload.updated_at.utc.to_date.to_s.should == "2000-01-01"
    @should_keep_no_role.roles.should == [@other_role]

    @should_gain_role.reload.roles.should == [role]
    @should_gain_role.updated_at.to_date == Date.today

    @dup_person_id.reload.roles.should == [role]
    @dup_person_id.updated_at.to_date == Date.today

    @other_user.reload.roles.sort.should == []
    @other_user2.reload.roles.sort.should == [role,@other_role].sort
    @other_user3.reload.roles.sort.should == [role].sort

  end
  #end

end
