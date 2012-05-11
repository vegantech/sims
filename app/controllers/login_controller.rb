class LoginController < ApplicationController
  include CountryStateDistrict
  skip_before_filter :authenticate, :authorize, :verify_authenticity_token

  #There is a potential for csrf attacks for logout which would be annoying for the user, but not really harmful
  #same for login, but there really would be no reason to trick a user into logging in as someone else.   The tradeoff here is for usability
  #There are often errors from a logout form that get invalidated by a server restart showing an error to the user.   This should eliminate those errors
  layout 'main'

  def login
    dropdowns
    @user=User.new(:username=>params[:username])
    session[:user_id] = nil
    if request.post? and current_district
      forgot_password and return if params[:forgot_password]
      @user=current_district.users.authenticate(params[:username], params[:password]) || @user
      session[:user_id] = @user.id
      if @user.new_record?
        logger.info "Failed login of #{params[:username]} at #{current_district.name}"
        current_district.logs.create(:body => "Failed login of #{params[:username]}") unless current_district.new_record?
        if @user.token
          flash.now[:notice] = 'An email has been sent, follow the link to change your password.'
        else
          flash.now[:notice] = 'Authentication Failure'
        end
      else
        @user.record_successful_login
        session[:district_id]=current_district.id
        current_user = @user
        redirect_to successful_login_destination and return
      end
    end
    @district = current_district #LH582

  end

  def logout
    oldflash = flash[:notice]
    reset_session_and_district
    dropdowns
    flash[:notice] = oldflash
    render :action=>:login #the redirect wasn't properly clearing the cookie via the reset_session
  end

  def index
    login
    render :action=>"login"
  end

  def change_password
    reset_session_and_district if params['token'].present?
    @user = current_user

    if @user.new_record?
      id=params[:id] || (params[:user] && params[:user][:id])
      token = params['token'] || (params[:user] && params['user'][:token])
      if Time.now.utc.to_i > token.split("-").last.to_i
        flash[:notice] = "The authentication token has expired"
        redirect_to logout_url and return
      else
        @user =  User.where(:token => token).find(id)
      end
      redirect_to logout_url if @user.blank?
    end

    if request.put?
      if @user.change_password(params['user'])
        flash[:notice] = 'Your password has been changed'
        redirect_to root_url
      end
    end
 end

private
  def reset_session_and_district
    reset_session
    current_user = User.new
    session[:district_id]=nil
  end

  def successful_login_destination
    return session[:requested_url] if session[:requested_url]
    return root_url_with_subdomain
  end

  def forgot_password
    @user=current_district.users.find_by_username(params[:username]) || @user
    if current_district.forgot_password?
      if @user.email?
        @user.create_token unless @user.new_record?
        flash.now[:notice] = 'An email has been sent, follow the link to change your password.'
      else
        flash.now[:notice] = 'User does not have email assigned in SIMS.  Contact your LSA for assistance'
      end
    else
      flash.now[:notice] = "This district does not support password recovery.  Contact your LSA for assistance"
    end
  end

end


