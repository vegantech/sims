Given /^an intervention with no progress monitors$/ do
  intervention = Factory(:intervention, student: @student, user_id: 222)
end

Given /^an intervention with one progress monitor chosen but no recommended monitors$/ do
  intervention = Factory(:intervention,student: @student)
  ipa = Factory(:intervention_probe_assignment, intervention: intervention)
end


Given /^an intervention with one progress monitor chosen and one recommended monitor$/ do
  intervention = Factory(:intervention,student: @student)
  ipa = Factory(:intervention_probe_assignment, intervention: intervention)
  intervention.intervention_definition.probe_definitions << ipa.probe_definition
end


Given /^an intervention with two progress monitors but none selected$/ do
  intervention = Factory(:intervention,student: @student)
  intervention.intervention_definition.probe_definitions << Factory(:probe_definition, title: "First Progress Monitor")
  intervention.intervention_definition.probe_definitions << Factory(:probe_definition, title: "Second Progress Monitor")
end

# <select onchange="$('spinnerassign_progress').show(); new Ajax.Updater('intervention_probe_assignment', 'http://localhost:3333/interventions/ajax_probe_assignment', {asynchronous:true, evalScripts:true, method:'get', onSuccess:function(request){$('spinnerassign_progress').hide();}, parameters:'id=' + $('intervention_intervention_probe_assignment_probe_definition_id').value + '&amp;intervention_id=184330825' + '&amp;authenticity_token=' + encodeURIComponent('y8JC6pkZq5A1TeDKjKAyCRU5sRzodSD27pTWfebGgkI=')})" name="intervention[intervention_probe_assignment][probe_definition_id]" id="intervention_intervention_probe_assignment_probe_definition_id" class="fixed_width">


#  <a href="?enter_score=true" onclick="new Ajax.Request('/interventions/1/probe_assignments?probe_definition_id=1', {asynchronous:true, evalScripts:true, method:'get', onLoading:function(request){$('spinnerscore_link').show();}}); return false;">Enter/view scores</a>

# Given /^I should see javascript code that will do xhr for "search_criteria_grade" that updates ["search_criteria_user_id", "search_criteria_group_id"]$/ do
Given /^I should see onchange for "(.*)" that updates (.*)$/ do |observed_field, target_fields|
  # field_labeled(observed_field).should match(/Ajax.Updater\('#{target_fields}'/)
  field_labeled(observed_field).native.to_s.should match(/onchange/)
  field_labeled(observed_field).native.to_s.should match(/Ajax.Updater/)
  field_labeled(observed_field).native.to_s.should match(/#{target_fields}/)
end


When /^I should see onchange for "([^\"]*)" that calls "([^\"]*)"$/ do |observed_field, target|
  field_labeled(observed_field).native.to_s.should match(/onchange/)
  field_labeled(observed_field).native.to_s.should match(/#{target}/)
end


When /^xhr "([^\"]*)" "([^\"]*)"$/ do |event, field|

  case event
  when "onchange"
    if field == "Assign Progress Monitor"
      field_element = find_field(field).value
      pd = ProbeDefinition.find_by_id(field_element) || ProbeDefinition.find_by_title(field_element) || ProbeDefinition.new
      page.visit "/interventions/ajax_probe_assignment/?intervention_id=#{@student.interventions.first.id.to_s}&id=#{pd[:id]}"
    else
      fail
    end
  when "onclick"
    if field == "enter_view_score_link"
      i_id =  @student.interventions.first.id.to_s

     page.visit "/interventions/#{i_id}/probe_assignments?probe_definition_id=#{ ProbeDefinition.first.id}&format=js"
    else
      fail
    end
  else
    fail
  end
end



# When /^xhr "search_criteria_user_id" updates ["search_criteria_group_id"]
When /^22222222xhr "(.*)" updates (.*)$/ do |observed_field, target_fields|
  user = User.find_by_username("default_user")
  other_guy = User.find_by_username("Other_Guy")
  school = School.find_by_name("Central")

  if observed_field == "search_criteria_grade"
    xml_http_request  :post, "/students/grade_search/", {grade: 3}, {user_id: user.id.to_s, school_id: school.id.to_s}
  elsif observed_field == "search_criteria_user_id"
    xml_http_request  :post, "/students/member_search/", {grade: 3,user: other_guy.id.to_s}, {user_id: user.id.to_s, school_id: school.id.to_s}
  else
    flunk response.body
  end

  Array(eval(target_fields)).each do |target_field|
    response.body.should match(/Element.update\("#{target_field}"/)
  end
  #  response.should hav_text /"<option value=\"996332878\">default user</option>");"/
end

Then /^22222I should verify rjs has options (.*)$/ do |options|
  response.should have_options(Array(eval(options)))
end


