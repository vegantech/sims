class MainController < ApplicationController
  skip_before_filter :authenticate, :authorize, :only=>:index
  include  CountryStateDistrict
  def index
    redirect_to logout_url if current_district.blank? and current_user_id.present?
    if can? :read, School
      redirect_to schools_url and return
    end
    dropdowns

    
  end

end
