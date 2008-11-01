class StudentsController < ApplicationController
	before_filter :enforce_session_selections, :except => [:index, :select, :search, :new, :create]

  # GET /students
  # GET /students.xml
  def index
    @students = current_school.enrollments.search(session[:search])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end

  def select
    # add selected students to session redirect to show

    # need to make sure user has access to these
    session[:selected_students] = params[:id]
    if session[:selected_students].blank?
      flash[:notice] = 'No students selected'
      redirect_to students_url
    else
      session[:selected_student] = session[:selected_students].first
      redirect_to student_url(session[:selected_student])
    end
  end

  def search
    if request.get?
      @grades = current_school.enrollments.collect(&:grade).uniq
      @grades.unshift("*")

      student_groups
      group_users
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

  def student_groups
    @groups=current_school.groups
  end

  def group_users
    #TODO this is just a placeholder
    @users=current_school.users
    #@groups.collect(&:users).uniq.first || []
  end

end
