module StudentsHelper
  def selected_navigation
    if multiple_selected_students?
      index = selected_student_ids.index(current_student_id)
      ret = "Student #{index+1} of #{selected_student_ids.size} &nbsp;&nbsp; "

      unless index == 0
        ret += link_to('<<', student_url(selected_student_ids.first))
        ret += "&nbsp;&nbsp;"
        ret += link_to('Previous', student_url(selected_student_ids[index-1]))
        ret += "&nbsp;&nbsp;"
      end

      unless index == (selected_student_ids.size() -1)
        ret += link_to('Next', student_url(selected_student_ids[index+1]))
        ret += "&nbsp;&nbsp;"
        ret += link_to('>>', student_url(selected_student_ids.last))
      end
      content_tag :p, ret.html_safe
    end
  end

  def intervention_group_checkbox(grp)
    content_tag :div, :class => "small_bump_right" do
    check_box_tag("intervention_group_types[]",grp.id,false,:id=>dom_id(grp), :class => 'active_intervention_checkbox') +
      label_tag(dom_id(grp), grp.title)
    end.html_safe
  end

  def active_intervention_size
    current_district.objective_definitions.size
  end
  def active_intervention_select
    current_district.objective_definitions.inject(''){|result, grp| result += intervention_group_checkbox(grp)}.html_safe
  end

  def id_district_desc(obj)
    obj_text=obj.class.name.downcase
  "District identifier for this #{obj_text} (the #{obj_text}_id or primary_key in your SIS)"
  end

  def id_state_desc(obj)
    obj_text = obj.class.name.downcase
    "State identifier for this #{obj_text} (the id used by your state DPI)"
  end

  def id_country_desc(obj)
    obj_text = obj.class.name.downcase
    "National identifier for this #{obj_text} (the ID used by the Deptartment of Education)"
  end

  def extended_profile(student)
    if !student.new_record? && student.extended_profile?
      student.extended_profile
    end
  end

  def team_notes_count(student)
    content_tag :span, "(#{student.comments.size})", :id => 'team_notes_count'
  end

  def active_interventions_count(student)
    content_tag :span, "(#{student.interventions.active.size})", :id =>'active_interventions_count'
  end

  def inactive_interventions_count(student)
    content_tag :span, "(#{student.interventions.inactive.size})", :id => 'inactive_interventions_count'
  end

  def grade_select(grades)
    grades.unshift("*") if grades.length > 1
    select(:search_criteria,:grade,grades)
  end

  def year_select(years)
    years.unshift(["All","*"])
    select(:search_criteria,:year,years)
  end

  def group_select_options(groups)
    if groups.length > 1 or current_user.all_students_in_school?(current_school)
      groups.unshift(Group.new(:title=>'Filter by Group'))
    end
    groups
  end

  def group_member_select_options(members)
    members.unshift(User.new(:first_name=>'All', :last_name=>'Staff')) if members.size > 1 or current_user.all_students_in_school?(current_school)
    members
  end
end
