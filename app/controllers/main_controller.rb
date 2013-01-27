class MainController < ApplicationController
  skip_before_filter :authenticate_user!, :only=>[:not_authorized, :change_password]
  skip_before_filter :authorize
  skip_before_filter :verify_authenticity_token

  def index
    redirect_to logout_url and return if current_district.blank? and user_signed_in?
    if current_user and current_user.schools.present?
      redirect_to schools_url, :notice => flash[:notice] and return
    end
  end

  def not_authorized
    render :action => :index
  end

  def change_password
    @user = current_user

    if request.put?
      if params['user'] && params['user']['password'].present?
        if @user.update_with_password(params['user'])
          sign_in @user, :bypass => true
          flash[:notice] = 'Your password has been changed'
          redirect_to root_url
        end
      else
        @user.errors.add(:password, 'cannot be blank')
      end
    end
 end


end
