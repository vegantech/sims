class TeamNotesReport
  def initialize(options={})
    @user = options[:user]
    @school = options[:school]
    @start_date = options[:start_date]
    @end_date = options[:end_date]
    @sort_field = options[:sort_field] || 'Student'
    @content = options[:content].to_s
  end

  def team_notes
    if @sort_field == "Student"
      base_order = ["students.last_name, students.first_name", "student_comments.created_at", "body"]
    elsif @sort_field == "Date"
      base_order = ["student_comments.created_at","students.last_name, students.first_name", "body"]
    elsif @sort_field == "Team Note"
      base_order = ["body","student_comments.created_at","students.last_name, students.first_name"]
    end

    student_ids = StudentSearch.search({:search_type =>'list_all',
                 :school_id => @school.id, :user => @user}).pluck(:student_id)
    StudentComment.includes([:student,:user]).where(
    ["body like ?", "%#{@content}%"]).where(
    :created_at => @start_date.beginning_of_day..@end_date.end_of_day,
    :student_id => student_ids).order(base_order)
  end

  def grouped_team_notes
    if @sort_field == "Student"
      team_notes.all.group_by(&:student)
    else
      team_notes.all.group_by{nil}
    end
  end
end
