class Users::SessionsController < Devise::SessionsController
  rescue_from Devise::ChangingPasswordInsteadOfFailedLogin, :with => :change_password_instead_of_login
  layout 'main'

  def create
    if params["forgot_password"]
      reset_password and return
    else
      super
    end
  end

  def new
    #Users who are signed in, but go directly to the login page
    #are prompted to log in, but stay as the previous user
    sign_out if user_signed_in? 
    #fix for above
    if session["user_return_to"]
      p=Rack::Utils.parse_nested_query(URI.parse(session["user_return_to"]).query)
      params["district_abbrev"] ||= (p["district_abbrev"].presence || current_subdomain.presence)
      @current_district = nil if current_district.new_record?
      params.deep_merge!("user" => {"username" => p["username"]}) if p["username"]
    end
    super
  end

  private

  def change_password_instead_of_login
    throw(:warden, :message => I18n.t("devise.sessions.user.send_instructions"))
  end

  def reset_password
    self.resource = User.send_reset_password_instructions(params[:user])

    if successfully_sent?(resource)
      respond_with({}, :location => new_user_session_url)
    else
      flash[:alert]= resource.errors.full_messages
      self.resource = User.new(resource.attributes.except('district_id').merge(:district_id_for_login => resource.district_id))
      render :action => 'new'
    end
  end

end
