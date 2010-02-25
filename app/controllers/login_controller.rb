class LoginController < ApplicationController
  include CountryStateDistrict
  skip_before_filter :authenticate, :authorize, :verify_authenticity_token

  #There is a potential for csrf attacks for logout which would be annoying for the user, but not really harmful
  #same for login, but there really would be no reason to trick a user into logging in as someone else.   The tradeoff here is for usability
  #There are often errors from a logout form that get invalidated by a server restart showing an error to the user.   This should eliminate those errors
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
        current_district.logs.create(:body => "Failed login of #{params[:username]}")
        HoptoadNotifier.notify :error_message=>"Failed login of #{params[:username]} at #{current_district.name}" if Rails.env == "production"
        if @user.token
          flash[:notice] = 'An email has been sent, follow the link to change your password.'
        else
          flash[:notice] = 'Authentication Failure'
        end
      else
        current_district.logs.create(:body => "Successful login of #{@user.fullname}")
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

  def change_password
    @user = current_user

    if @user.new_record? 
      id=params[:id] || (params[:user] && params[:user][:id])
      token = params[:token] || (params[:token] && params['user'][:token])
      @user =  User.find(id, :conditions => ["passwordhash ='' and salt ='' and token = ?",token]) #and email_token
      redirect_to logout if @user.blank?
    end

    if request.put?
      if @user.change_password(params['user'])
        flash[:notice] = 'Your password has been changed'
        redirect_to root_url
      end
    end
 end

 
private
  def successful_login_destination
    return session[:requested_url] if session[:requested_url]
    begin
    if ENABLE_SUBDOMAINS 
      district_state_and_country = [current_district.abbrev,current_district.state.abbrev, current_district.state.country.abbrev]
      subdomain = district_state_and_country.join('-') #and Object.const_defined?('SIMS_DOMAIN') and request.host.include?(Object.const_get('SIMS_DOMAIN'))
    end
    return root_url(:subdomain=>subdomain)
    rescue NameError
    end
      root_url()
  end

  
end


