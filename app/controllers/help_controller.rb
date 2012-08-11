class HelpController < ApplicationController
  skip_before_filter :authenticate_user!, :authorize

  def show
    @file=CGI.escape(params[:id].gsub(/\./,""))
  end

end
