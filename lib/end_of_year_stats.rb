class EndOfYearStats
  attr_accessor :start_date, :end_date

  def initialize(opts={})
    @start_date=(opts[:start_date] || default_start_date).to_s(:db)
    @end_date=(opts[:end_date] || default_end_date).to_s(:db)
    @district=opts[:district]
  end

  def mmsd_schools_with_data
    #should generate csv in date range
    rows=[]
    @district.schools.each do |school|
      row =[]
      row << school.district_school_id
      row << school.name
      row << school.id_state
      tot=0
      int_count = Intervention.count(:all, :joins => {:student => :enrollments}, 
                                     :conditions => {:enrollments =>{:school_id => school.id},
                                       :interventions=>{:created_at => @start_date..@end_date}})
      row << int_count
      tot += int_count

      team_notes = StudentComment.count(:all, :joins => {:student => :enrollments}, 
                                     :conditions => {:enrollments =>{:school_id => school.id},
                                       :student_comments=>{:created_at => @start_date..@end_date}})
      row << team_notes
      tot += team_notes

      checklists = Checklist.count(:all, :joins => {:student => :enrollments}, 
                                     :conditions => {:enrollments =>{:school_id => school.id},
                                       :checklists=>{:created_at => @start_date..@end_date}})
      row << checklists
      tot += checklists

      recommendations = Recommendation.count(:all, :joins => {:student => :enrollments}, 
                                     :conditions => {:enrollments =>{:school_id => school.id},
                                       :recommendations=>{:created_at => @start_date..@end_date}})
      row << recommendations
      tot += recommendations

     custom_flags = CustomFlag.count(:all, :joins => {:student => :enrollments}, 
                                     :conditions => {:enrollments =>{:school_id => school.id},
                                       :flags=>{:created_at => @start_date..@end_date}})
      row << custom_flags
      tot += custom_flags

      team_consultations = TeamConsultation.count(:all, :joins => {:student => :enrollments}, 
                                     :conditions => {:enrollments =>{:school_id => school.id},
                                       :team_consultations=>{:created_at => @start_date..@end_date}})
      row << team_consultations
      tot += team_consultations

      probe_count = Probe.count(:all, :joins => {:intervention_probe_assignment=>{:intervention=>{:student => :enrollments}}}, 
                                     :conditions => {:enrollments =>{:school_id => school.id},
                                       :probes=>{:created_at => @start_date..@end_date}})
      row << probe_count
      tot += probe_count

      intervention_comments = InterventionComment.count(:all, :joins => {:intervention=>{:student => :enrollments}}, 
                                     :conditions => {:enrollments =>{:school_id => school.id},
                                       :intervention_comments=>{:created_at => @start_date..@end_date}})
      row << intervention_comments
      tot += intervention_comments






      rows << row if tot>0
    end



    puts "district_school_id,name,id_state,interventions,team_notes,checklists,recommendations,custom_flags,team_consultations,progress_monitor_scores,intervention_comments"


#    puts "team_notes, team_consultations, checklists, recommendations, custom_flags,progress_monitor_scores, interventions
#    schoolname, district_school_id, state_dpi_num, intervention_comments"
    rows.each{|r| puts r.to_csv}
    nil
  end

  def mmsd_students_with_data(end_year=@end_date.to_date.year)
    #should generate csv in date range
    ##do enrollments include student and school

    end_year_cond = "end_year = #{end_year}" if end_year
    

    objs=@district.objective_definitions.find(:all,:include=>:goal_definition)

    rows=[]
    @district.enrollments.find(:all,:include => [:student,:school], :conditions => end_year_cond).each do |enrollment|
      student=enrollment.student
      school=enrollment.school
      row=[]
      tot=0
      row << school.name
      row << school.district_school_id
      row << student.fullname
      row << student.district_student_id
      row << student.number

      team_notes = StudentComment.count(:all, 
                                     :conditions => {:student_id => student.id,
                                       :created_at => @start_date..@end_date})
      row << team_notes
      tot += team_notes

      checklists = Checklist.count(:all,
                                     :conditions => {:student_id => student.id,
                                       :created_at => @start_date..@end_date})
      row << checklists
      tot += checklists

      recommendations = Recommendation.count(:all,
                                     :conditions => {:student_id => student.id,
                                       :created_at => @start_date..@end_date})
      row << recommendations
      tot += recommendations

     custom_flags = CustomFlag.count(:all,
                                     :conditions => {:student_id => student.id,
                                       :created_at => @start_date..@end_date})
      row << custom_flags
      tot += custom_flags

      team_consultations = TeamConsultation.count(:all,
                                     :conditions => {:student_id => student.id,
                                       :created_at => @start_date..@end_date})
      row << team_consultations
      tot += team_consultations

      intervention_comments = InterventionComment.count(:all, :joins => :intervention, 
                                     :conditions => {:interventions =>{:student_id => student.id},
                                       :intervention_comments=>{:created_at => @start_date..@end_date}})
      row << intervention_comments
      tot += intervention_comments




      probe_count = Probe.count(:all, :joins => {:intervention_probe_assignment=>:intervention}, 
                                     :conditions => {:interventions =>{:student_id => student.id},
                                       :probes=>{:created_at => @start_date..@end_date}})
      row << probe_count
      tot += probe_count

      objs.each do |obj|
        int_count = 0
        int_count = Intervention.count(:all, :joins => [:student, {:intervention_definition => :intervention_cluster}], 
                                     :conditions => {:intervention_clusters=>{:objective_definition_id => obj.id},:student_id => student.id,
                                      :created_at => @start_date..@end_date})
        row << int_count
        tot += int_count
      end






      rows << row if tot >0
    end

    obs_string = objs.collect{|o| objective_title_with_goal(o)}.join(",")
    puts "school_name,district_school_id,student_name,district_student_id,number,team_notes,checklists,recommendations,intervention_comments,progress_monitor_scores,#{obs_string}"
    rows.each{|r| puts r.to_csv}
    nil
  end

  def default_start_date
    Date.civil((Date.today - (8.months)).year, 9)
  end

  def default_end_date
    Date.civil((Date.today + (3.months)).year, 7)
  end

  def objective_title_with_goal(obj)
    "#{obj.goal_definition.title}-#{obj.title}".gsub(/ /,"_")
  end




end
