Given /^an intervention with no progress monitors$/ do
  Factory(:intervention,:student => @student, :intervention_definition => InterventionDefinition.first, :user => @user)
end

Given /^an intervention with one progress monitor chosen but no recommended monitors$/ do

  intervention = Factory(:intervention,:student => @student, :intervention_definition => InterventionDefinition.first, :user => @user)
  ipa=Factory(:intervention_probe_assignment, :intervention => intervention, :probe_definitions => ProbeDefinition.first)
end


Given /^an intervention with one progress monitor chosen and one recommended monitor$/ do
  intervention = Factory(:intervention,:student => @student, :intervention_definition => InterventionDefinition.first, :user => @user)

  ipa=Factory(:intervention_probe_assignment, :intervention => intervention, :probe_definition => ProbeDefinition.first)
  intervention.intervention_definition.probe_definitions << ipa.probe_definition
end


Given /^an intervention with two progress monitors but none selected$/ do
  intervention = Factory(:intervention,:student => @student,:intervention_definition => InterventionDefinition.first, :user => @user)

  intervention.intervention_definition.probe_definitions << Factory(:probe_definition, :title => "First Progress Monitor", :district=>@student.district)
  intervention.intervention_definition.probe_definitions << Factory(:probe_definition, :title => "Second Progress Monitor", :district => @student.district)
end

# <select onchange="$('spinnerassign_progress').show(); new Ajax.Updater('intervention_probe_assignment', 'http://localhost:3333/interventions/ajax_probe_assignment', {asynchronous:true, evalScripts:true, method:'get', onSuccess:function(request){$('spinnerassign_progress').hide();}, parameters:'id=' + $('intervention_intervention_probe_assignment_probe_definition_id').value + '&amp;intervention_id=184330825' + '&amp;authenticity_token=' + encodeURIComponent('y8JC6pkZq5A1TeDKjKAyCRU5sRzodSD27pTWfebGgkI=')})" name="intervention[intervention_probe_assignment][probe_definition_id]" id="intervention_intervention_probe_assignment_probe_definition_id" class="fixed_width">


#  <a href="?enter_score=true" onclick="new Ajax.Request('/interventions/1/probe_assignments?probe_definition_id=1', {asynchronous:true, evalScripts:true, method:'get', onLoading:function(request){$('spinnerscore_link').show();}}); return false;">Enter/view scores</a>     


When /^I should see onchange for "([^\"]*)" that calls "([^\"]*)"$/ do |observed_field, target|
  f=find_field(observed_field)
  f[:onchange].to_s.should match(/#{target}/)
end


When /^xhr "([^\"]*)" "([^\"]*)"$/ do |event, field|
  set_headers({"HTTP_X_REQUESTED_WITH" => "XMLHttpRequest"})
  set_headers({"HTTP_X_HTTP_METHOD_OVERRIDE"=>"GET"})
  set_headers({"REQUEST_METHOD"=>"GET"})

  case event
  when "onchange"
    if field == "Assign Progress Monitor"
#     @xhr= xml_http_request :get, "/interventions/ajax_probe_assignment/", {:intervention_id => @student.interventions.first.id.to_s, :id=>field_labeled(field).value}, {:user_id => @user.id.to_s, :school_id => @school.id.to_s}
     visit "/interventions/ajax_probe_assignment.js?intervention_id=#{@student.interventions.last.id.to_s}&id=#{find_field(field).value}"
    else 
      fail
    end
  when "onclick"
    if field == "enter_view_score_link"
      
      i_id =  @student.interventions.last.id.to_s

     visit "/interventions/#{i_id}/probe_assignments.js?probe_definition_id=#{ProbeDefinition.first.id}"
     # xhr :get, "/interventions/#{i_id}/probe_assignments", {:probe_definition_id => ProbeDefinition.first.id},  {:user_id => @user.id.to_s, :school_id => @school.id.to_s}
    else 
      fail
    end
  else
    fail
  end
end
  



# When /^xhr "search_criteria_user_id" updates ["search_criteria_group_id"]
When /^22222222xhr "(.*)" updates (.*)$/ do |observed_field, target_fields|
  user=User.find_by_username("default_user")
  other_guy=User.find_by_username("Other_Guy")
  school=School.find_by_name("Central")

  if observed_field == "search_criteria_grade"
    xml_http_request  :post, "/students/grade_search/", {:grade=>3}, {:user_id => user.id.to_s, :school_id=>school.id.to_s}
  elsif observed_field == "search_criteria_user_id"
    xml_http_request  :post, "/students/member_search/", {:grade=>3,:user=>other_guy.id.to_s}, {:user_id => user.id.to_s, :school_id=>school.id.to_s}
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


