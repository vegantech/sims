module District::SchoolsHelper
  def add_user_school_assignment_link(name)
    link_to_function name do |page| 
      page.insert_html :bottom, :user_school_assignments, :partial => 'user_school_assignment', :object => UserSchoolAssignment.new 
    end
  end
end