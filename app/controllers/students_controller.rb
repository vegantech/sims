class StudentsController < ApplicationController
	before_filter :enforce_session_selections, :except => [:index, :select, :search, :new, :create]

  # GET /students
  # GET /students.xml
  def index
    @students = current_user.authorized_enrollments_for_school(current_school).search(session[:search])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end

  def select
    # add selected students to session redirect to show
    
    @students = current_user.authorized_enrollments_for_school(current_school).search(session[:search])
    student_ids = @students.collect {|s| s.student.id.to_s}
    if params[:id].blank?
      flash[:notice] = 'No students selected'
    elsif student_ids.to_set.subset?(params[:id].to_set)
      session[:selected_students] = params[:id]
      session[:selected_student] = session[:selected_students].first
      redirect_to student_url(session[:selected_student]) and return
    else
      flash[:notice] = 'Unauthorized Student selected'
    end
    session[:selected_students]= nil
    session[:selected_student]= nil
    render :action=>"index" 
  end

  def search
    if request.get?
      @grades = current_school.grades_by_user(current_user)
      @grades.unshift("*") if @grades.size >1

      @users=group_users
      @groups=student_groups
    else
      if params['search_criteria']
        session[:search] = params['search_criteria'] ||{}
        session[:search]['flagged_intervention_types'] = params['flagged_intervention_types']
        session[:search]['intervention_group_types'] = params['intervention_group_types']
        session[:search][:intervention_group] = current_district.search_intervention_by.class_name if session[:search][:intervention_group_types]
        redirect_to students_url
      else
        flash[:notice] = 'Missing search criteria'
        redirect_to :action => :search
      end
    end
  end

  # GET /students/1
  # GET /students/1.xml
  def show
    @student = current_school.students.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end


  #RJS methods for search page

  def grade_search
    grade=params[:grade]
    @users=filter_members_by_grade(grade)
    @groups=filter_groups_by_grade(grade)

  end
 
  def member_search
    grade=params[:grade]
    user=params[:user]

    if user.blank?
      @groups=filter_groups_by_grade(grade)
    else
      #filter by grade and user
      groups=filter_groups_by_grade(grade)
      @groups=filter_groups_by_user(user,groups)
    end

    
  end

 

  private
  def enforce_session_selections
    return true unless params[:id]
		# raise "I'm here" if selected_students_ids.nil?
    if selected_students_ids and selected_students_ids.include?(params[:id])
      session[:selected_student]=params[:id]
      return true
    else
      flash[:notice]='Student not selected'
      redirect_to students_url and return false
    end
  end


  ### TODO move all of these into the models
  def student_groups
    groups=current_user.authorized_groups_for_school(current_school)
    groups.unshift(Group.new(:id=>"*",:title=>"Filter by Group")) if groups.size > 1 or current_user.special_user_groups.all_students_in_school?(current_school)
    groups
  end

  def group_users
    users=current_user.authorized_groups_for_school(current_school).members
    users.unshift(User.new(:id=>"*",:first_name=>"Filter",:last_name=>"by Group Member")) if users.size > 1 or current_user.special_user_groups.all_students_in_school?(current_school)
    users
  end

  def filter_members_by_grade(grade)
     if grade == "*"
      group_users
    else
      group_users.select do |group_user|
        #group has a student in the grade
        group_user.groups.any? do |group|
          group.students.find(:first,:include=>:enrollments,:conditions=>["enrollments.grade=?",grade])
        end
      end
    end
  end

  def filter_groups_by_grade(grade, groups=student_groups)
    if grade == "*"
      groups
    else
      student_groups.select do |group|
        group.students.find(:first,:include=>:enrollments,:conditions=>["enrollments.grade=?",grade])
      end
    end
  end

  def filter_groups_by_user(user_id, groups=student_groups)
    result = groups.select do |group|
      group.users.exists?(user_id.to_i)
    end
    result
  end

end
