class DistrictsController < ApplicationController
  before_filter :state_admin?, :only => [:index, :new, :create, :reset_password, :recreate_admin ]

  # GET /districts
  def index
    @districts = District.for_dropdown

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
    @district = District.normal.build(params[:district])

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
    @district = District.normal.find(params[:id])
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

  def export
    send_file(DistrictExport.generate(current_district), :type => 'application/zip', :x_sendfile => true)

  end


  def bulk_import_form
     @uuid = CGI.escape((0..29).to_a.map {|x| rand(10)}.join )
  end

  def bulk_import
   # TODO REFACTOR THIS
    if request.post?
      @results = 'Starting to process'
      Rails.cache.write("#{current_district.id}_import",'')
      DistrictUploadJob.new.async_perform params[:import_file], current_district
      ActiveRecord::Base.connection.reconnect!
      @results = Rails.cache.read("#{current_district.id}_import")
      append_reload_js_to_results
      render #:layout => 'bulk_import'
    else
      @results =
        Rails.cache.read("#{current_district.id}_import")
      append_reload_js_to_results
      if request.xhr?
        render :text => @results + Time.now.to_s and return
      end
    end
  end

private
  def state_admin?
    unless current_district.admin?
      flash[:notice] = 'You do not have access to this action'
      redirect_to root_url
    end
  end

  def append_reload_js_to_results
    @results = '' if @results.nil?
    unless @results.match(/#{ImportCSV::EOF}/)
      @results <<"<script>setTimeout(function(){
                                   $('#import_results').load('/districts/bulk_import');
                                       }, 5000);</script>"
    end

  end

end
