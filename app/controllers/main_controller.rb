class MainController < ApplicationController
  skip_before_filter :authenticate, :authorize, :only=>:index
  include  CountryStateDistrict
  def index
    dropdowns
  end

end
