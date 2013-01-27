class HelpController < ApplicationController
  skip_before_filter :authenticate_user!, :authorize, :check_domain

  def show
    @file=CGI.escape(params[:id].gsub(/\./,""))
  end

end
