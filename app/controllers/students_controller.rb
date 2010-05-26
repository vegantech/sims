class StudentsController < ApplicationController
	before_filter :enforce_session_selections, :except => [:index, :select, :search]
  additional_read_actions %w{grade_search member_search search}

  # GET /students
  # GET /students.xml
  def index
    flash[:notice]="Please Choose a school" and redirect_to schools_url  and return unless current_school_id
    flash[:notice]= "Please choose some search criteria" and redirect_to search_students_url and return unless session[:search]
    @students = student_search index_includes=true
    @flags_above_threshold= flags_above_threshold
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end

  def select
    # add selected students to session, then redirect to show

    @students = student_search
    authorized_student_ids = @students.collect {|s| s.student.id.to_s}

    if params[:id].blank?
      flash[:notice] = 'No students selected'
    # elsif authorized_student_ids.to_set.subset?(params[:id].to_set)
    elsif params[:id].to_set.subset?(authorized_student_ids.to_set)
      max_students = 250
      params[:id].uniq!
      if params[:id].length > max_students
        flash[:notice] ="Selection limited to #{max_students} students"
        params[:id] = params[:id][0...max_students]
      end
      session[:selected_students] = params[:id]
      session[:selected_student] = session[:selected_students].first
      redirect_to student_url(session[:selected_student]) and return
    else
      flash[:notice] = 'Unauthorized Student selected'
    end
    session[:selected_students]= nil
    session[:selected_student]= nil

   @flags_above_threshold= flags_above_threshold


    render :action=>"index" 
  end

  def search
    if request.get?
      @grades = current_school.grades_by_user(current_user) unless current_school.blank?

      flash[:notice] = "User doesn't have access to any students at #{current_school}" and redirect_to schools_url and return if @grades.blank?

      @groups=current_user.filtered_groups_by_school(current_school)
      @users=current_user.filtered_members_by_school(current_school)
      @years = current_school.enrollment_years
   else
      if params['search_criteria']
        session[:search] = params['search_criteria'] ||{}
        session[:search]['flagged_intervention_types'] = params['flagged_intervention_types']
        session[:search]['intervention_group_types'] = params['intervention_group_types']
        session[:search][:intervention_group] = current_district.search_intervention_by.first.class.name if session[:search][:intervention_group_types]
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
    @student = Student.find(params[:id])
    if @student.district_id != current_district.id
      flash[:notice] = 'Student not enrolled in district'
      redirect_to :action=>:index and return
    end
        

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # RJS methods for search page

  def grade_search
    @users=current_user.filtered_members_by_school(current_school,params)
    @groups=current_user.filtered_groups_by_school(current_school,params)
  end

  def member_search
    @groups=current_user.filtered_groups_by_school(current_school,params)
  end

  private

  def flags_above_threshold
      if  session[:search][:search_type] == 'flagged_intervention' 
        []
      else
        current_district.flag_categories.above_threshold(@students.collect(&:student_id))
      end
  end

  def enforce_session_selections
    return true unless params[:id]
		# raise "I'm here" if selected_students_ids.nil?
    if selected_students_ids and selected_students_ids.include?(params[:id])
      session[:selected_student]=params[:id]
      return true
    else
     return ic_entry if params[:id] == "ic_jump"
      student=Student.find(params[:id])
      if student.belongs_to_user?(current_user)
        session[:school_id] = (student.schools & current_user.authorized_schools).first
        session[:selected_student]=params[:id]
        session[:selected_students]=[params[:id]]
        return true
      end

      flash[:notice]='You do not have access to that student'
      redirect_to students_url and return false
    end
  end

  def student_search(index_includes=false)
    session[:search] ||= {}
    Enrollment.search(session[:search].merge(
      :school_id => current_school_id,
      :user => current_user,
      :index_includes =>index_includes))
  end

  def ic_entry
      session[:user_id]= nil if current_user.district_user_id.to_s != params[:personID]
      student = current_district.students.find_by_district_student_id(params[:contextID])
      if student
        session[:requested_url]= student_url(student,:username => params[:username])
      else
        session[:requested_url] = root_url
        flash[:notice] = 'Student is not enrolled in this district'
      end
      redirect_to session[:requested_url] and return false
  end
end
