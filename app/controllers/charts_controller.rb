class ChartsController < ApplicationController
  skip_before_filter :authorize, :authenticate
  require 'net/http'
  require 'uri'

  def show
   
    k= Net::HTTP.get("chart.apis.google.com", "/chart?#{request.query_string}")
    send_data k, {:type =>'image/png', :disposition => 'inline'}
  end

end
