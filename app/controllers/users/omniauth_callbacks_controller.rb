class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token, :only => [:google_apps, :windowslive]

  def windowslive
    email = request.env['omniauth.auth']['extra']['raw_info']['emails']['account']
    @user = current_district.users.where(:email => email).first

    if @user.present?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Windows Live"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] ="User not found"
      redirect_to new_user_session_url
    end
  end

  def google_oauth2
    params[:district_abbrev] = params[:state]

    @user = current_district.users.find_for_googleapps_oauth(request.env["omniauth.auth"], current_user)

    if @user.present?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] ="User not found"
      redirect_to new_user_session_url(subdomain: params[:state])
    end
  end


  def after_sign_in_path_for(resource)
    if request.subdomain == "auth"
      root_url(subdomain: params[:state]) + super[1..-1]
    else
      super
    end
  end

end
