class StudentSearchesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /students
  # GET /students.xml
  def show
    check_school_and_set_grades or return false
    @groups=current_user.filtered_groups_by_school(current_school)
    @users=current_user.filtered_members_by_school(current_school)
    @years = current_school.enrollment_years
  end


  def create
    if params['search_criteria']
      session[:search] = params['search_criteria'] ||{}
      session[:search]['flagged_intervention_types'] = params['flagged_intervention_types']
      session[:search]['intervention_group_types'] = params['intervention_group_types']
      session[:search][:intervention_group] = current_district.search_intervention_by.first.class.name if session[:search][:intervention_group_types]
      redirect_to students_url
    else
      flash[:notice] = 'Missing search criteria'
      redirect_to :action => :show
    end
  end

  # RJS methods for search page

  def grade
    @users=current_user.filtered_members_by_school(current_school,params)
    @groups=current_user.filtered_groups_by_school(current_school,params)
  end

  def member
    @groups=current_user.filtered_groups_by_school(current_school,params)
  end

  private


  def check_school_and_set_grades
    @grades = check_school.grades_by_user(current_user)
    if @grades.blank?
      if current_school.students.empty?
        flash[:notice] = "#{current_school} has no students enrolled."
      else
        flash[:notice] = "User doesn't have access to any students at #{current_school}."
      end
      flash[:tag_back] = "student_search"
      redirect_to schools_url and return
    end
    return true
  end

  def check_school
    if params[:school_id] != current_school_id
      @school = current_user.schools.find(params["school_id"])
      session[:school_id] = @school.id
    end
    current_school
  end

end
