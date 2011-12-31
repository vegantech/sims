Given /^I am at the student profile page$/ do
  District.delete_all
  @student = Factory(:student)
  @school = Factory(:school, :district => @student.district)
  @enrollment = Factory(:enrollment, :school => @school, :student => @student)
  @user = Factory(:user, :district => @student.district, :all_students_in_district => '1', :roles => ['regular_user'])
  visit student_url(@student)
  fill_in "Login", :with =>@user.username
  fill_in 'Password', :with => @user.username
  click_button 'Login'
end

When /^I try to view an invalid checklist$/ do
    visit checklist_url("invalid")
end

Then /^I should be at the student profile page$/ do
  URI.parse(current_url).path.should == student_path(@student)
end

Then /^I should see a notice for "([^"]*)"$/ do |regexp|
  within "#flash_notice" do |content|
    content.should contain(regexp)
  end
end




