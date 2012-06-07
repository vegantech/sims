class MainController < ApplicationController
  skip_before_filter :authenticate, :authorize, :only=>[:index,:stats, :not_authorized]
  skip_before_filter :verify_authenticity_token

  def index
    redirect_to logout_url if current_district.blank? and current_user_id.present?
    if current_user and current_user.schools.present?
      redirect_to schools_url and return
    end
  end

  def not_authorized
    render :action => :index
  end

end
