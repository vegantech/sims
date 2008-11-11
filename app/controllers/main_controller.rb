class MainController < ApplicationController
  skip_before_filter :authenticate, :authorize, :only=>:index
  def index
  end

end
