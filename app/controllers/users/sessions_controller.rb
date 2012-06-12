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
    if session["user_return_to"]
      p=session["user_return_to"].split("?",2)[1]
      params["district_abbrev"] = Hash[*p.split("=")]["district_abbrev"] if p.present?
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
      self.resource = User.new(resource.attributes.merge(:district_id_for_login => resource.district_id))
      render :action => 'new'
    end
  end

end
