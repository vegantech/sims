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

def log_in
	@default_user ||= create_user 'default_user', 'd3f4ult'
	create_school 'Glenn Stephens'
	visits '/'
	fills_in 'Login', :with => 'default_user'
	fills_in 'Password', :with => 'd3f4ult'
	clicks_button 'Login'
	response.should_not have_text(/Authentication Failure/)
end

def create_user user_name, password
	encrypted_password = Digest::SHA1.hexdigest(password.downcase)
	  
	@default_user = User.create! :username => user_name,
		:first_name => 'First',
		:last_name => 'Last',
		:passwordhash => encrypted_password
end

def create_school school_name
	found = School.find_by_name(school_name)
	s = found || School.create!(:name => school_name)
	default_user.schools << s unless default_user.schools.include?(s)
	s
end

def create_student first_name, last_name, grade, school, flag_type = nil
	s = Student.create! :first_name => first_name, :last_name => last_name
	# :grade => grade
	enrollment = Enrollment.create! :grade => grade, :school => school
	s.enrollments << enrollment
	s.save!
	# t.string   "category"
	#   t.integer  "user_id"
	#   t.integer  "district_id"
	#   t.integer  "student_id"
	#   t.text     "reason"
	#   t.string   "type"
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
