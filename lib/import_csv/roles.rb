module ImportCSV::Roles
  
  def load_user_roles_from_csv file_name, role
    @role=Role::ROLES[role] or return false
    @existing_users = @district.users.find_all_by_role(role, :conditions => 'district_user_id is not null', :select => 'id, district_user_id')
#      @role.users.all(:conditions => ["district_id = ? and district_user_id is not null", @district.id],:select => "id, district_user_id")
    
    if load_from_csv file_name, "role"
      @desired_users = district.users(true).all(:select => "id, district_user_id", 
        :conditions => ["district_id = ? and district_user_id is not null and district_user_id in (?) ", @district.id,
        @ids.compact]
        )
      
      # insert desired - existing
      Role.add_users(role, @desired_users  -@existing_users)
      
      # remove existing - desired
      Role.remove_users(role,@existing_users - @desired_users)
    end
  end

  def process_role_line line
    @ids << line[:district_user_id]
  end
end
