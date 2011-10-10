START_DATE = "2011-07-01"
END_DATE = "2011-10-31"

e=DistrictLog.successful_login_non_admin.find(:all, :conditions => {:created_at => START_DATE..END_DATE}, :group => :district_id, :select => 'district_id, count(id) as total_logins, count(distinct user_id) as distinct_user_logins')
e=e.collect(&:attributes)
e=e.index_by{|f| f["district_id"]}

districts = District.find(e.keys)
res=districts.each do |district|
  e[district.id]["name"] = district.name
  e[district.id].delete "district_id"
  e[district.id]["checklists"] = Checklist.count(:conditions => {:created_at => START_DATE..END_DATE, :district_id => district.id})
  e[district.id]["recommendations"] = Recommendation.count(:joins => :student, :conditions => {:created_at => START_DATE..END_DATE, :students => {:district_id => district.id}})
  e[district.id]["interventions"] = Intervention.count(:joins => :student, :conditions => {:created_at => START_DATE..END_DATE, :students => {:district_id => district.id}})
  e[district.id]["students_with_intervention"] = Intervention.count(:select => 'distinct student_id', :joins => :student, :conditions => {:created_at => START_DATE..END_DATE, :students => {:district_id => district.id}})
  e[district.id]["custom_flags"] = CustomFlag.count(:joins => :student, :conditions => {:created_at => START_DATE..END_DATE, :students => {:district_id => district.id}})
  e[district.id]["team_notes"] = StudentComment.count(:joins => :student, :conditions => {:created_at => START_DATE..END_DATE, :students => {:district_id => district.id}})
  e[district.id]["students_with_team_notes"] = StudentComment.count(:select => 'distinct student_id', :joins => :student, :conditions => {:created_at => START_DATE..END_DATE, :students => {:district_id => district.id}})
  e[district.id]["intervention_comments"] = InterventionComment.count(:joins => {:intervention =>:student}, :conditions => {:created_at => START_DATE..END_DATE, :students => {:district_id => district.id}})
  e[district.id]["probe_scores"] = Probe.count(:joins => {:intervention_probe_assignment=>{:intervention =>:student}}, :conditions => {:created_at => START_DATE..END_DATE, :students => {:district_id => district.id}})
  e[district.id]["team_consultations"] = TeamConsultation.count(:joins => :student, :conditions => {:created_at => START_DATE..END_DATE, :students => {:district_id => district.id}})
  e[district.id]["team_consultation_responses"] = ConsultationForm.count(:joins => {:team_consultation => :student}, :conditions => {:created_at => START_DATE..END_DATE, :students => {:district_id => district.id}})
end


puts res.values.compact.first.keys.to_csv
res.values.compact.each{|r| puts r.values.to_csv};nil



