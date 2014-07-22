Given /^Shawn Balestracci is a team contact for "([^\"]*)"$/ do |team_name|
  u = Factory(:user, first_name: 'Shawn', last_name: 'Balestracci', email: 'b723176@madison.k12.wi.us', district: cucumber_district)
  @user ||= u
  st=cucumber_school.school_teams.find_or_create_by_name(team_name)
  st.contact_ids = [u.id]
  st.save!
end

When /^I follow "([^\"]*)" "([^\"]*)"$/ do |arg1, arg2|
  if arg2 == 'TODAY'
    date = Date.today
    arg1.sub!(/_CHANGE_TO_VARIABLE_/, "#{date}")
    When "I follow \"#{arg1}\""
  else
    fail
  end
end

When /^The district is set to email on responses$/ do
  @user.district.update_attribute :email_on_team_consultation_response, true
end

When /^The district is not set to email on responses$/ do
  @user.district.update_attribute :email_on_team_consultation_response, false
end

When /^I reload the team consultation based on the following table:$/ do |table|
  pg = current_path
  table.hashes.each do |row|
    #setting consultation? display?
    setting =  (row["setting"] == "false") ? false : true
    cucumber_district.update_attribute :show_team_consultations_if_pending, setting
    TeamConsultation.delete_all
    case row["consultation?"]
    when "open"
      step 'I follow "Create Team Consultation Form"'
      click_button 'Save'
    when 'draft'
      step 'I follow "Create Team Consultation Form"'
      click_button 'Save as Draft'
    when 'other_draft'
      step 'I follow "Create Team Consultation Form"'
      click_button 'Save as Draft'
      TeamConsultation.update_all requestor_id: -1
    when 'none'
    else
      raise "unknown #{row['consultation?']}"
    end
      visit pg
    css_sel= "#consultations_group"
    if row["display?"] == "true"
      page.should have_selector(css_sel,visible: true), row.inspect
    else
      @user.district.inspect
      page.should have_selector(css_sel, visible: false), row.inspect
    end
  end
end
