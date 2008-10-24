class LoginController < ApplicationController
  skip_before_filter :authenticate
  def login
    @user=User.new(:username=>params[:username])
    if request.get?
      session[:user_id] = nil
    else
      @user=User.authenticate(params[:username], params[:password]) || @user
      session[:user_id] = @user.id
      flash[:notice] = 'Authentication Failure' if @user.new_record?
      redirect_to root_url and return
    end

  end

  def logout
    oldflash = flash[:notice]
    reset_session
    flash[:notice] = "#{oldflash} Logged Out"
    redirect_to root_url
  end

  def index
    login
    render :action=>"login"
  end

 
end


