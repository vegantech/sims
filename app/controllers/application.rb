# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include HoptoadNotifier::Catcher
  include ControllerRights
  #TODO replace this default district constant

  helper :all # include all helpers, all the time
  helper_method :multiple_selected_students?, :selected_students_ids, 
    :current_student_id, :current_student, :current_district, :current_school, :current_user
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'f94867ed424ccea84323251f7aa373db'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password

  before_filter :authenticate, :authorize#, :current_district

  SUBDOMAIN_MATCH=/(sims)|(sims-open)/
  
  private
  def current_user_id
    session[:user_id]
  end

  def current_user
    @user=User.find_by_id(current_user_id) || User.new
  end

  def selected_students_ids
    session[:selected_students]  
  end

  def multiple_selected_students?
    selected_students_ids and selected_students_ids.size > 1
  end

  def current_student_id
    session[:selected_student]
  end


  def current_student
    @student ||=Student.find_by_id(current_student_id)
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
    unless current_user_id 
      flash[:notice] = "You must be logged in to reach that page"
      session[:requested_url] = request.url
      redirect_to root_url
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

  def self.show_read_actions
    puts "read actions are: #{@@read_actions.inspect}."
  end
 
  def self.additional_read_actions(*args)
     self.read_actions = Array(args).flatten.map(&:to_s)
  end

  def self.additional_write_actions(*args)
     self.write_actions= Array(args).flatten.map(&:to_s)
  end


  def subdomains
      g=self.request.subdomains
      if g.pop.to_s.match(SUBDOMAIN_MATCH)
         params[:country_abbrev],params[:state_abbrev],params[:district_abbrev]=g.reverse
      end
      return unless params[:country_abbrev]

      @country ||= Country.find_by_abbrev(params[:country_abbrev])
      if @country
        @countries=[]
        @state ||= @country.states.find_by_abbrev(params[:state_abbrev])
      end
      if @state
        @states=[]
        district = @state.districts.find_by_abbrev(params[:district_abbrev]) 
      end
      if district
        redirect_to logout_url and return if current_district and current_district != district
        @districts =[]
        @current_district = district
      end

  end

end
