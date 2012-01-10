# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ControllerRights
  #TODO replace this default district constant

  helper :all # include all helpers, all the time
  helper_method :multiple_selected_students?, :selected_student_ids,
    :current_student_id, :current_student, :current_district, :current_school, :current_user,
    :current_user_id, :index_url_with_page

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'f94867ed424ccea84323251f7aa373db'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password

  before_filter :fixie6iframe,:options_for_microsoft_office_protocol_discovery,:authenticate, :authorize#, :current_district

  SUBDOMAIN_MATCH=/(^sims$)|(^sims-open$)/
  
  private

  def current_user_id
    session[:user_id]
  end

  def current_user
    @current_user ||= (User.find_by_id(current_user_id) || User.new )
  end

  def student_id_cache_key
    "student_ids_#{current_user_id}_#{session[:session_id][0..40]}"
  end
  def selected_student_ids
    if session[:selected_students] == "memcache"
      @memcache_student_ids ||= Rails.cache.read(student_id_cache_key)
    else
      session[:selected_students]
    end
  end

  def selected_student_ids=(student_ids=[])
    if student_ids.blank? || student_ids.length <50
      session[:selected_students] = student_ids
    else
      session[:selected_students] = "memcache"
      Rails.cache.write(student_id_cache_key, student_ids)
    end
  end

  def multiple_selected_students?
    selected_student_ids.to_a.size > 1
  end

  def current_student_id
    session[:selected_student]
  end


  def current_student
    @student ||= Student.find_by_id(current_student_id)
  end

  def current_school_id
    session[:school_id]
  end

  def current_school
    @school ||= School.find_by_id(current_school_id)
  end

  def current_district_id
    session[:district_id]
  end

  def current_district
    @current_district ||= District.find_by_id(current_district_id)
  end

  def authenticate
    subdomains
    redirect_to logout_url() if current_district_id and current_district.blank?
    unless current_user_id 
      flash[:notice] = "You must be logged in to reach that page"
      session[:requested_url] = request.url
      redirect_to root_url(:username => params[:username])
      return false
    end
    true
  end

  def authorize
    controller = self.class.controller_path  # may need to change this
    action_group = action_group_for_current_action
    unless current_user.authorized_for?(controller, action_group)
      logger.info "Authorization Failure: controller is #{controller}. action_name is #{action_name}. action_group is #{action_group}."
      
      flash[:notice] =  "You are not authorized to access that page"
      redirect_to root_url
      return false
    end
    true
  end

  def require_current_school
    if current_school.blank?
      if request.xhr?
        render :update do  |page|
          page[:flash_notice].insert  "<br />Please reselect the school." 
        end
      else
        flash[:notice] = "Please reselect the school"
        redirect_to schools_url 
      end
      return false
    end
    return true
  end

  class_inheritable_array :read_actions,:write_actions
  self.read_actions = ['index', 'select', 'show', 'preview', 'read' , 'raw', 'part', 'suggestions']  #read raw and part are from railmail
  self.write_actions = ['create', 'update', 'destroy', 'new', 'edit', 'move', 'disable', 'disable_all', 'resend'] #resend is from railmail

  def action_group_for_current_action
    if self.class.write_actions.include?(action_name)
      'write_access'
    elsif self.class.read_actions.include?(action_name)
      #put in the defaults here,   override this and call super in individual controllers
      "read_access"
    else
      nil
    end
  end

  def self.additional_read_actions(*args)
     self.read_actions = Array(args).flatten.map(&:to_s)
  end

  def self.additional_write_actions(*args)
     self.write_actions= Array(args).flatten.map(&:to_s)
  end

  def subdomains
    if current_subdomain
      g=current_subdomain
      s=g.split("-").reverse
      params[:district_abbrev] = s.pop
    end
        district = District.find_by_abbrev(params[:district_abbrev]) 
      if district
        redirect_to logout_url and return if current_district and current_district != district
        @districts =[]
        @current_district = district
      end
  end

  rescue_from(ActiveRecord::RecordNotFound) do
    respond_to do |format|
      format.html do
        flash[:notice]='Record not found'
        begin
          redirect_to :back
        rescue ActionController::RedirectBackError
          redirect_to root_url
        end
      end
      format.js {render :nothing => true}
    end
  end


  def options_for_microsoft_office_protocol_discovery
    render :nothing => true, :status => :ok if request.method == :options #:ok => 200
  end

  def fixie6iframe
    response.headers['P3P']= 'CP = "CAO PSA OUR"'
  end

def check_student
    #TODO generalize this
    student=Student.find_by_id(params[:student_id]) || Student.new

    if student.belongs_to_user?(current_user)
      @student=student
    else
      flash[:notice] = "The student is not accessible for this user"
      respond_to do |format|
        format.js { render :template => "/main/inaccessible_student.js"}
        format.html  {redirect_to :back }
      end
     return false
    end

  end

  def edit_obj_link(u)
    self.class.helpers.link_to u, self.send("edit_#{patherize_controller.singularize}_path",u)
  end

  def capture_paged_controller_params
    session[:paged_controller]={:path => params[:controller], :opts =>{ :last_name => params[:last_name],:page => params[:page], :title => params[:title] }}
  end

  def index_url_with_page
    if session[:paged_controller] && session[:paged_controller][:path] == params[:controller]
      self.send("#{patherize_controller}_path", session[:paged_controller][:opts])
    else
      self.send("#{patherize_controller}_path")
    end
  end

  def patherize_controller
    params[:controller].gsub(/\//,"_")
  end

  def wp_out_of_bounds?(wp_collection)
    wp_collection.out_of_bounds? && wp_collection.total_entries > 0
  end

  def current_user=(user)
    session[:user_id] = user.id
    @curret_user = user
  end
end
