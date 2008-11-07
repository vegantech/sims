def go_to_page page_name
	page_name = page_name.sub(/^the /i, '').sub(/ page$/i, '')

	if page_name == 'home'
		visits '/'
	else
		log_in
		# flunk response.body
		clicks_link 'School Selection'

		case page_name.sub(/^the /i, '').sub(/ page$/i, '')
		when 'search'
			clicks_button 'Choose School'
		when 'school selection'
		else
			raise "Can't find mapping from \"#{page_name}\" to a path"
		end
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

private

def default_user
	@default_user ||= create_user 'default_user', 'd3f4ult'
end
