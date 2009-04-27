module BuilderHelper
  def add_user_school_assignment_link(name)
    link_to_function name do |page| 
      page.insert_html :bottom, :user_school_assignments, :partial => "user_school_assignment", :object => UserSchoolAssignment.new 
    end
  end

  def new_probe_definition(pd=ProbeDefinition.new)
    pd.assets.build if pd.assets.blank?
    pd.probe_definition_benchmarks.build if pd.probe_definition_benchmarks.blank?
    pd
  end
end
