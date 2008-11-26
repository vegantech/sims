def go_to_page page_name
	page_name = page_name.sub(/^the /i, '').sub(/ page$/i, '')

	if page_name == 'home'
		visits '/'
	else
		log_in
		# flunk response.body
		clicks_link 'School Selection'

		page_name = page_name.sub(/^the /i, '').sub(/ page$/i, '')

		case page_name
		when 'search'
			clicks_button 'Choose School'
		when 'school selection'
    when 'new role'
    when 'student profile'
      # search
      selects("Default School")
      clicks_button "Choose School"
      clicks_button "Search for Students"
      click_all_name_id_brackets
      clicks_button "select for problem solving"
		else
			raise "Can't find mapping from \"#{page_name}\" to a path"
		end
	end
end

def click_all_name_id_brackets
  doc=Hpricot(response.body)
  doc.search("//input[@name='id[]']").each do |elem|
    checks(elem[:id])
  end
end

def verify_select_box id, options
  options=Array(eval(options))
	response.should have_dropdown(id, options)
end

def log_in
	default_user
	create_school 'Glenn Stephens'
	visits '/'
	fills_in 'Login', :with => 'default_user'
	fills_in 'Password', :with => 'd3f4ult'
	clicks_button 'Login'
	response.should_not have_text(/Authentication Failure/)
end


def find_or_create_user user_name
  User.find_by_username(user_name) || create_user(user_name)
end

def create_user user_name, password=''
	encrypted_password = Digest::SHA1.hexdigest(password.downcase)
	  
	user=User.create! :username => user_name,
		:first_name => user_name.split("_").first || 'First',
		:last_name => user_name.split("_").last || 'Last',
		:passwordhash => encrypted_password
end

def create_school school_name
	found = School.find_by_name(school_name)
	s = found || School.create!(:name => school_name)
	default_user.schools << s unless default_user.schools.include?(s)
	@school||=s
  s
end

def grant_access user_name, group_array
  user = find_or_create_user user_name
  groups = Array(eval(group_array))
  groups.each do |group_title|
    group = Group.find_by_title(group_title)
    raise "Missing group: '#{group_title}'" if group.nil?
    UserGroupAssignment.create!(:user => user, :group => group)
  end
end

def find_student first_name, last_name
  Student.find(:first, :conditions => {:first_name => first_name, :last_name => last_name})
end

def create_student first_name, last_name, grade, school, flag_type = nil
	s = Student.create! :first_name => first_name, :last_name => last_name
	# :grade => grade
	enrollment = Enrollment.create! :grade => grade, :school => school
	s.enrollments << enrollment
	s.save!

	if flag_type
		f = Flag.create!(:student => s,
			:category => flag_type,
			:reason => 'some reason or another',
			:type => 'system',
			:user => @default_user)
	end
  s
end

def create_default_user
  #TODO Possibly refactor this out  change access
  default_user
end

def create_default_school
  @school||=create_school "Default School"
end

def create_default_student
  @student ||= create_student "Common", "Last", "04", @school
  g=Group.create!(:title=>"Default Group")
  g.students << @student
  g.save!
  @default_user.groups << g
  @default_user.save!
 
  @default_user.special_user_groups.create!(:grouptype=>SpecialUserGroup::ALL_STUDENTS_IN_SCHOOL,:school_id=>@school.id)
  District.destroy_all
  @district=District.create!(:name=>"Default District", :students =>[@student])

  @student
end

def create_default_intervention_pieces
  g1=@district.goal_definitions.create!(:title=>"Some Goal",:description=>"whatever")
  @district.goal_definitions.create!(:title=>"Goal 1",:description=>"whatever")
  o1=g1.objective_definitions.create!(:title=>"Some Objective",:description=>"whatever")
  g1.objective_definitions.create!(:title=>"Other Objective",:description=>"whatever")
  c1=o1.intervention_clusters.create!(:title=>"Some Category",:description=>"whatever")
  o1.intervention_clusters.create!(:title=>"Other Category",:description=>"whatever")
  d1=c1.intervention_definitions.make!(:title=>"Other Definition")
  

end

private

def default_user
	@default_user ||= create_user 'default_user', 'd3f4ult'
  default_role = Role.create!(:name => 'Default Role', :district_id => 1, :users=>[@default_user])
  Right.create!(:role => default_role, :controller => 'students', :read => true)
  Right.create!(:role => default_role, :controller => 'schools', :read => true)

  ["interventions", "interventions/goals", "interventions/objectives", "interventions/categories", "interventions/objectives"].each do |c|
    default_role.rights.create!(:controller=>c, :read=> true, :write => true)
  end


  #put other stuff above this
  @default_user
end
