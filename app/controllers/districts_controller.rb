class DistrictsController < ApplicationController
  additional_write_actions :reset_password, :recreate_admin, :bulk_import
  additional_read_actions :bulk_import_form
  
  # GET /districts
  def index
    @state = current_district.state
    @districts = @state.districts.normal

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /districts/new
  def new
    @district = District.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /districts/1/edit
  def edit
    @district = current_district
  end

  # POST /districts
  def create
    @district = current_district.state.districts.normal.build(params[:district])

    respond_to do |format|
      if @district.save
        flash[:notice] = 'District was successfully created.'
        format.html { redirect_to(districts_url)}
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /districts/1
  def update
    @district = current_district

    respond_to do |format|
      if @district.update_attributes(params[:district])
        flash[:notice] = 'District was successfully updated.'
        format.html { redirect_to(root_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /districts/1
  def destroy
    @district = current_district.state.districts.normal.find(params[:id])
    @district.destroy
    flash[:notice] = @district.errors[:base]

    respond_to do |format|
      format.html { redirect_to(districts_url) }
    end
  end
  
  def reset_password
    @district=District.find(params[:id])
    flash[:notice]= @district.reset_admin_password!
    redirect_to(districts_url)
  end

  def recreate_admin
    @district=District.find(params[:id])
    flash[:notice]= @district.recreate_admin!
    redirect_to(districts_url)
  end


  def bulk_import_form
    
  end

  def bulk_import
    file = params[:import_file]
    base_file_name = File.basename(file.original_filename).downcase 
   
    
    if base_file_name == "users.csv"
      ImportCSV::load_users_from_csv file.path,current_district
      flash[:notice]= "Your import was successful"
    elsif base_file_name =~ /\.zip$/
      flash[:notice] = ImportCSV::process_zip file.path,current_district
    else
      flash[:notice] = "Unknown file"
    end

    
    redirect_to root_url
  end


end
