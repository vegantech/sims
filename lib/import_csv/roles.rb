module ImportCSV::Roles
  
  def load_user_roles_from_csv file_name, role
    @role=Role.find_by_name(role) or return false
    @existing_users = @role.users.all(:conditions => ["district_id = ? and district_user_id is not null", @district.id],:select => "id, district_user_id")
    
    if load_from_csv file_name, "role"
      @desired_users = district.users(true).all(:select => "id, district_user_id", 
        :conditions => ["district_id = ? and district_user_id is not null and district_user_id in (?) ", @district.id,
        @ids.compact]
        )
      
      # insert desired - existing
      @role.users << (@desired_users  -@existing_users)
      
      # remove existing - desired
      @role.users.delete(@existing_users - @desired_users)
    end
  end

  def process_role_line line
    @ids << line[:district_user_id]
  end
end
