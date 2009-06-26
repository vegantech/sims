class CountriesController < ApplicationController
  additional_write_actions :reset_password, :recreate_admin
  before_filter :system_admin?, :only => [:index, :new, :create, :reset_password, :recreate_admin ]
  # GET /countries
  # GET /countries.xml
  def index
    @countries = Country.normal

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @countries }
    end
  end

  # GET /countries/new
  # GET /countries/new.xml
  def new
    @country = Country.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @country }
    end
  end

  # GET /countries/1/edit
  def edit
    @country = current_district.country
  end

  # POST /countries
  # POST /countries.xml
  def create
    @country = Country.new(params[:country])

    respond_to do |format|
      if @country.save
        flash[:notice] = 'Country was successfully created.'
        format.html { redirect_to(countries_url) }
        format.xml  { render :xml => @country, :status => :created, :location => @country }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /countries/1
  # PUT /countries/1.xml
  def update
    @country = current_district.country

    respond_to do |format|
      if @country.update_attributes(params[:country])
        flash[:notice] = 'Country was successfully updated.'
        format.html { redirect_to(root_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /countries/1
  # DELETE /countries/1.xml
  def destroy
    @country = Country.find(params[:id])
    @country.destroy
    flash[:notice]=@country.errors[:base]

    respond_to do |format|
      format.html { redirect_to(countries_url) }
      format.xml  { head :ok }
    end
  end

  def reset_password
    @country=Country.find(params[:id])
    flash[:notice]= @country.admin_district.reset_admin_password!
    redirect_to(countries_url)
  end

  def recreate_admin
    @country=Country.find(params[:id])
    flash[:notice]= @country.admin_district.recreate_admin!
    redirect_to(countries_url)
  end

  private
  def system_admin?
    current_district.system_admin?
  end

  
end
