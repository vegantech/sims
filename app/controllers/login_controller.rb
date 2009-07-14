class LoginController < ApplicationController
  include CountryStateDistrict
  skip_before_filter :authenticate, :authorize
  layout 'main'
  def login
    dropdowns
    @user=User.new(:username=>params[:username])
    session[:user_id] = nil
    
    if request.post? and current_district
      @user=current_district.users.authenticate(params[:username], params[:password]) || @user
      session[:user_id] = @user.id
      if @user.new_record?
        logger.info "Failed login of #{params[:username]} at #{current_district.name}"
        HoptoadNotifier.notify :error_message=>"Failed login of #{params[:username]} at #{current_district.name}" if Rails.env == "production"
        flash[:notice] = 'Authentication Failure'
      else
        logger.info "Successful login of #{@user.fullname} at #{current_district.name}"
        session[:district_id]=current_district.id
        redirect_to successful_login_destination and return
      end
    end

  end

  def logout
    oldflash = flash[:notice]
    reset_session
    session[:user_id]=nil
    session[:district_id]=nil
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

 
private
  def successful_login_destination
    return session[:requested_url] if session[:requested_url]
    if request.subdomains.last.to_s.match(SUBDOMAIN_MATCH) or request.host == "www.simspilot.org"
      district_state_and_country = [current_district.abbrev]
      district_state_and_country << current_district.state.abbrev 
      district_state_and_country << current_district.state.country.abbrev
      existing_subdomain=".#{request.subdomains.last}" unless System::RESERVED_SUBDOMAINS.include?request.subdomains.last
      "#{request.protocol}#{district_state_and_country.join("-")}#{existing_subdomain}.#{request.domain}#{request.port_string}/"
    else
      root_url
    end

  end

  
end


