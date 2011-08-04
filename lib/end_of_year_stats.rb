class EndOfYearStats
  attr_accessor :start_date, :end_date

  def initialize(opts={})
    @start_date=opts[:start_date] || default_start_date
    @end_date=opts[:end_date] || default_end_date
  end

  def mmsd_schools_with_data
    #should generate csv in date range
    puts "team_notes, team_consultations, checklists, recommendations, custom_flags,progress_monitor_scores
    schoolname, district_school_id, state_dpi_num, intervention_comments"
  end

  def mmsd_students_with_data
    #should generate csv in date range
    puts "student name, district_student_id,number, count_of_team_notes,checklists,recommendations,goal-objective.each(intervention_count),intervention_comments,progress_monitor_scores
    (goal-objective.each)engagement-attendance,learning-math"
  end

  def default_start_date
    Date.civil((Date.today - (8.months)).year, 9)
  end

  def default_end_date
    Date.civil((Date.today + (3.months)).year, 7)
  end




end
