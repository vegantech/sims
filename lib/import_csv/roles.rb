module ImportCSV::Roles
  
  def load_user_roles_from_csv file_name, role
    @role=Role.find_by_name(role) or return false
    @existing_users = @role.users.all(:conditions => ["district_id = ? and id_district is not null", @district.id],:select => "id, id_district")
    
    if load_from_csv file_name, "role"
      @desired_users = district.users(true).all(:select => "id, id_district", 
        :conditions => ["district_id = ? and id_district is not null and id_district in (?) ", @district.id,
        @ids.compact]
        )
      
      #insert desired - existing
      @role.users << (@desired_users  -@existing_users)
      
      #remove existing - desired
      @role.users.delete(@existing_users - @desired_users)
    end
      
  end

  def process_role_line line
    @ids << line[:id_district]
  end


end

