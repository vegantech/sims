class Role 

  SYSTEM_ROLES ={
                  "district_admin" => 'Add a logo, set the district key, add users, add schools, 
                  assign roles, add students, enroll students, import files, set district abbreviation',
                  "content_admin" => 'Setup Goals, Objectives, Categories, Interventions, Tiers, Checklists, and Progress Monitors', 
                  "school_admin" => 'Create groups, assign students and groups, maintain quicklist', 
                  "regular_user" => 'Regular user of SIMS', 
                  "news_admin"  => 'Create and edit news items that appear on the left' , 
                  "state_admin" => 'Creates and edits states',
                  "country_admin" => 'Creates and edits countries'
                }



  ROLES = %w{ district_admin content_admin school_admin regular_user news_admin state_admin country_admin}
  CSV_HEADERS = [:district_user_id]

  HELP = {
    "district_admin" => [{:name => "Change your logo and url", :url=> "/help/edit_district"}]
  }

  HELP.default = []




#  acts_as_list # :scope =>[:district_id,:state_id, :country_id, :system]  need to fix this
#  named_scope :system, :conditions => {:district_id => nil}


  def self.cache_key
    Digest::MD5.hexdigest(constants.collect{|c| const_get(c)}.to_s)
  end


  def self.mask_to_roles(mask)
    Role::ROLES.reject do |r|
      ((mask || 0) & 2**Role::ROLES.index(r)).zero?
    end
  end

  def self.roles_to_mask(roles=[])
    (Array(roles) & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def self.has_controller_and_action_group?(controller,action_group,roles)
    return false unless %w{ read_access write_access }.include?(action_group)
    roles.any?{|r| Right::RIGHTS[r.to_s].detect{|right| right[:controller] == controller && right[action_group.to_sym]}}
  end

  def self.add_users(name, users)
    unless ROLES.index(name).nil?
      User.update_all("roles_mask = roles_mask | #{2**ROLES.index(name)}",{:id=>Array(users)}) 
    end
  end

  def self.remove_users(name,users)
    unless ROLES.index(name).nil?
      User.update_all("roles_mask = roles_mask & ~#{2**ROLES.index(name)}",{:id=>Array(users)}) 

    end

  end
end
