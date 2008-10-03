Given /user "(.*)" with password "(.*)" exists/ do |user_name, password|
	encrypted_password = Digest::SHA1.hexdigest(password.downcase)

	User.create! :username => user_name,
							:first_name => 'First',
							:last_name => 'Last',
							:passwordhash => encrypted_password
end

Given /I am on the search page/ do
	visits '/schools'
  visits '/students/search'
end
