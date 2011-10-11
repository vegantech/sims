module BuilderHelper
  def add_user_school_assignment_link(name)
    if @users || @schools
      link_to_function name do |page|
        page.insert_html :bottom, :user_school_assignments, :partial => "user_school_assignment", :object => UserSchoolAssignment.new
      end
    else
      "<p>There are more than 100 users in the district; please assign new  school assignments through the add/remove users interface.</p>"
    end
  end

  def add_user_staff_assignment_link(name,fields)
    link_to_function name do |page|
      fields.fields_for(:staff_assignments, StaffAssignment.new) do |staff_assignment|
        page.insert_html :bottom, :user_staff_assignments, :partial => "staff_assignment", :object => staff_assignment
      end
    end
  end



  def new_probe_definition(pd=ProbeDefinition.new)
#    pd.assets.build if pd.assets.blank?
#    pd.probe_definition_benchmarks.build if pd.probe_definition_benchmarks.blank?
    pd
  end

  def exempt_tiers_box form, popup
    str = ""
    if current_district.lock_tier?
      str += "<p><div class='fake_label'>"
      str += form.check_box(:exempt_tier)
      str += "</div>"
      str += form.label(:exempt_tier, "Available to all tiers", {:class => "checkbox_label_span"})
      str += help_popup(popup)
      str += "</p>"
    end
    str
  end

end
