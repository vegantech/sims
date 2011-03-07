require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

  describe "role importer", :shared =>true  do
    before(:all) do
      District.delete_all
      User.delete_all
      @no_role_or_district_user_id = Factory(:user)
      @district = @no_role_or_district_user_id.district
      @role_no_district_user_id = Factory(:user,:district_id => @district.id, :roles=>[role])
      @should_lose_role = Factory(:user,:district_id => @district.id, :roles=>[role], :district_user_id => 'should_lose_role')
      @should_keep_role = Factory(:user,:district_id => @district.id, :roles=>[role], :district_user_id => 'should_keep_role')
      @should_keep_no_role = Factory(:user,:district_id => @district.id, :roles=>[], :district_user_id => 'should_keep_no_role')
      @should_gain_role = Factory(:user,:district_id => @district.id, :district_user_id => 'should_gain_role')
      @dup_person_id = Factory(:user,:district_id => @district.id, :district_user_id => @should_gain_role.district_user_id)
      @district.users.update_all("updated_at = '2000-01-01'")
      @i=myclass.new "#{Rails.root}/spec/csv/roles_base.csv",@district
      @i.import


      @no_role_or_district_user_id.reload.roles.should == []
      @role_no_district_user_id.reload.roles.should == [role]
      @should_keep_role.reload.roles.should == [role]
      @should_keep_role.updated_at.utc.to_date.to_s.should == "2000-01-01"
      @should_lose_role.reload.roles.should == []
      @should_lose_role.updated_at.to_date == Date.today

      @should_keep_no_role.reload.updated_at.utc.to_date.to_s.should == "2000-01-01"
      @should_keep_no_role.roles.should == []

      @should_keep_role.reload.updated_at.utc.to_date.to_s.should == "2000-01-01"
      @should_keep_role.roles.should == [role]

      @should_gain_role.reload.roles.should == [role]
      @should_gain_role.updated_at.to_date == Date.today

      @dup_person_id.reload.roles.should == [role]
      @dup_person_id.updated_at.to_date == Date.today



    end
    #end

  end
