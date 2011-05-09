class CicoController < ApplicationController
  skip_before_filter :authenticate, :authorize, :verify_authenticity_token
  #this is just to demo the check in checkout form and will be stripped out eventually

  def index
  end
  
end


