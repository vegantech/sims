class StudentFlagReport
  def current_flagged_students
    @search[:search_type]='flagged_intervention'
    students = StudentSearch.search(@search).collect(&:student).compact.uniq
  end

  def current_flags
    # TODO FIXME This needs to be refactored
    # system flags and ignore flags &! custom flag
    # combine the reasons
    # group by category, student_id
    # order by category, student
    cur_flags = Hash.new([])

    current_flagged_students.each do |stu|
      stu.flags.current.each do |category, flags|
        f=flags.first
        f.reason = flags.collect(&:summary).join("; ")
        cur_flags[category] = cur_flags[category] + [f]
      end
    end
    cur_flags
  end

  def custom_flags
    @search[:flagged_intervention_types]=['custom']
    students = StudentSearch.search(@search).collect(&:student).compact.uniq
  end

  def ignore_flags
    @search[:flagged_intervention_types]=['ignored']
    students = StudentSearch.search(@search).collect(&:student).compact.uniq
  end

  def initialize(options = {})
    @search=options
    @search[:flagged_intervention_types]=[]
  end
end
