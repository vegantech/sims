class StudentsController < ApplicationController
  before_filter :enforce_session_selections, :except => [:index, :create, :search]
  skip_before_filter :verify_authenticity_token
  helper_method :index_cache_key


  # GET /students
  def index
    try_to_auto_select_school or return false unless current_school_id
    flash[:notice]= "Please choose some search criteria" and redirect_to [current_school,StudentSearch] and return unless session[:search]


    @students = student_search(index_includes=true)

    setup_students_for_index

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def create
    # add selected students to session, then redirect to show

    @students = student_search( index_includes=true)
    authorized_student_ids = @students.collect {|s| s.id.to_s}

    if params[:id].blank?
      flash.now[:notice] = 'No students selected'
    # elsif authorized_student_ids.to_set.subset?(params[:id].to_set)
    elsif params[:id].to_set.subset?(authorized_student_ids.to_set)
      self.selected_student_ids = Array(params[:id]).uniq
      self.current_student_id = selected_student_ids.first
      redirect_to student_url(current_student_id) and return
    else
      flash.now[:notice] = 'Unauthorized Student selected, try searching again'
    end
    self.selected_student_ids = nil
    self.current_student_id = nil

    setup_students_for_index


    render :action=>"index"
  end

  # GET /students/1
  def show
    @student = Student.find(params[:id])
    if @student.district_id != current_district.id
      flash[:notice] = 'Student not enrolled in district'
      redirect_to :action=>:index and return
    end

    current_student_id || self.current_student_id = @student.id.to_s  #537 hopefully this will fix it
    respond_to do |format|
      format.html # show.html.erb
    end
  end


  private

  def flags_above_threshold
      if  session[:search][:search_type] == 'flagged_intervention'
        []
      else
        current_district.flag_categories.above_threshold(@students.collect(&:id))
      end
  end

  def enforce_session_selections
    return true unless params[:id]
		# raise "I'm here" if selected_students_ids.nil?
    if selected_student_ids and selected_student_ids.include?(params[:id])
      self.current_student_id=params[:id]
      return true
    else
     return ic_entry if params[:id] == "ic_jump"
      student=Student.find(params[:id])
      if student.belongs_to_user?(current_user)
        session[:school_id] = (student.schools & current_user.schools).first.id
        session[:selected_student]=params[:id]
        self.selected_student_ids=[params[:id]]
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
    #TODO FIXME
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

  def try_to_auto_select_school
    s=current_user.schools
    if s.size == 1
      session[:school_id] = s.first.id
      flash.now[:notice]=s.first.name + "has been automatically selected"
      return true
    else
      flash[:notice]="No school selected."
      redirect_to schools_url
      return false
    end
  end

  def setup_students_for_index
    if cache_configured?
      cache_keys =@students.collect{|s| index_cache_key(s)}
      @cached_status = Rails.cache.read_multi(*cache_keys)
      misses= (cache_keys - @cached_status.keys)
      missed_students =@students.select{|s| misses.include?(index_cache_key(s))}
    else
      missed_students = @students
    end
    ActiveRecord::Associations::Preloader.new(missed_students,
      [{:custom_flags=>:user}, {:interventions => :intervention_definition},
                    {:flags => :user}, {:ignore_flags=>:user} ]).run
    @flags_above_threshold= flags_above_threshold
  end

  def index_cache_key(s)
    fragment_cache_key ["status_display", s]
  end

end
