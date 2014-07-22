module BreadcrumbsHelper
  def breadcrumbs
    # 357 TODO add a test , if district admin had a student selected breadcrumb breaks when they do a new student
    [
      root_crumb,
      school_crumb,search_crumb,
      students_crumb,
      current_student_crumb
    ].compact.join(' -> ').html_safe
  end

  private
  def root_crumb
    link_to('Home', root_path)
  end

  def school_crumb
    link_to_unless_current('School Selection', schools_path) if session[:school_id]
  end

  def search_crumb
    link_to_unless_current('Student Search', [current_school,:student_search]) if session[:search]
  end

  def students_crumb
    link_to_unless_current('Student Selection', students_path) if session[:search]
  end

  def current_student_crumb
    link_to_unless_current(current_student, student_path(current_student)) if current_student.try(:persisted?)
  end
end
