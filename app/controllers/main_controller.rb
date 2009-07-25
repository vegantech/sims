class MainController < ApplicationController
  skip_before_filter :authenticate, :authorize, :only=>:index
  include  CountryStateDistrict
  def index
    if current_user and current_user.authorized_schools.present? and current_user.authorized_for?('schools','read_access')
      redirect_to schools_url and return
    end
    dropdowns

    
  end

end
