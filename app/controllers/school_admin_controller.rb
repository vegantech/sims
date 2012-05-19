class SchoolAdminController < ApplicationController
  private
  def authorize
    unless current_user.admin_of_school? current_school
      logger.info "Authorization Failure: controller is #{self.class.controller_path}"
      flash[:notice] =  "You are not authorized to access that page"
      redirect_to not_authorized_url
      return false
    else
      return true
    end
  end
end
