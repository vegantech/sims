class LoginController < ApplicationController
  include CountryStateDistrict
  skip_before_filter :authenticate, :authorize
  layout 'main'
  def login
    dropdowns
    @user=User.new(:username=>params[:username])
    
    if request.get?
      session[:user_id] = nil
    else
      if current_district
        @user=current_district.users.authenticate(params[:username], params[:password]) || @user
      end
      session[:user_id] = @user.id
      if @user.new_record?
        flash[:notice] = 'Authentication Failure' if @user.new_record?
      else
        session[:district_id]=current_district.id if current_district
        redirect_to session[:requested_url] and return if session[:requested_url]
      end

      if request.subdomains.size == 4 || request.subdomains.size == 0 || @user.new_record?
        redirect_to root_url and return
      elsif r=request.subdomains.last.match(SUBDOMAIN_MATCH)
        district_state_and_country = [current_district.abbrev]  if request.subdomains.size <4
        district_state_and_country << current_district.state.abbrev  if request.subdomains.size <3
        district_state_and_country << current_district.state.country.abbrev if request.subdomains.size < 2
        redirect_to "#{request.protocol}#{district_state_and_country.join(".")}.#{request.host_with_port}/"
      end

    end

  end

  def logout
    oldflash = flash[:notice]
    reset_session
    session[:user_id]=nil
    session[:district_id]=nil
    flash.now[:notice] = "#{oldflash} Logged Out"
    dropdowns
    render :action=>:login #the redirect wasn't properly clearing the cookie via the reset_session
  end

  def index
    login
    render :action=>"login"
  end

  def choose_country
    @country=Country.find(params[:country][:id])
    if request.subdomains.to_s.match(SUBDOMAIN_MATCH) && @country
      redirect_to "#{request.protocol}#{@country.abbrev}.#{request.host_with_port}" and return
    end
    dropdowns
    render :action=>"login"
  end

  def choose_state
    @state=State.find(params[:state][:id])
    @country=@state.country
    if request.subdomains.last.to_s.match(SUBDOMAIN_MATCH) && @state
     state_and_country=[@state.abbrev]
      if request.subdomains.size == 1 then 
        state_and_country << @state.country.abbrev
      end

      redirect_to "#{request.protocol}#{state_and_country.join(".")}.#{request.host_with_port}" and return
    end
    @user=User.new
    dropdowns
    render :action => "login"
  end

 
end


