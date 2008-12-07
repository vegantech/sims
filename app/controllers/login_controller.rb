class LoginController < ApplicationController
  include CountryStateDistrict
  skip_before_filter :authenticate, :authorize
  def login
    dropdowns
    @user=User.new(:username=>params[:username])
    
    if request.get?
      session[:user_id] = nil
    else
      @user=current_district.users.authenticate(params[:username], params[:password]) || @user
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

  def choose_country
    @country=Country.find(params[:country][:id])
    @user=User.new
    dropdowns
    render :action=>"login"
  end

  def choose_state
    @state=State.find(params[:state][:id])
    @country=@state.country
    @user=User.new
    dropdowns
    render :action => "login"
  end

 
end


