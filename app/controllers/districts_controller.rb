class DistrictsController < ApplicationController
  before_filter :state_admin?, :only => [:index, :new, :create, :reset_password, :recreate_admin ]

  # GET /districts
  def index
    @districts = District.normal

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
    send_file(DistrictExport.generate(current_district), :type => 'applciation/zip', :x_sendfile => true)

  end

  
  def bulk_import_form
     @uuid = (0..29).to_a.map {|x| rand(10)}
  end

  def bulk_import
   # TODO REFACTOR THIS

    if request.post?
      MEMCACHE.set("#{current_district.id}_import",'') if defined?MEMCACHE
      spawn_block do
        begin
          importer= ImportCSV.new params[:import_file], current_district
          x=Benchmark.measure{importer.import}

          @results = "#{importer.messages.join(", ")} #{x}"
          #request redirect_to root_url
        rescue => e
          Rails.logger.error "Spawn Exception #{Time.now} #{e.message}"
          Airbrake.notify(
            :error_class => "Spawn Error",
            :error_message => "Spawn Error: #{e.message}"
          )
          MEMCACHE.set("#{current_district.id}_import", "We're sorry, but something went wrong.  We've been notified and will take a look at it shortly.#{ImportCSV::EOF}") if defined?MEMCACHE
          raise e
        end

      end
      render :layout => 'bulk_import'
    else
      if defined?MEMCACHE
        @results =
          MEMCACHE.get("#{current_district.id}_import")
        @results.to_s.gsub!(/#{ImportCSV::EOF}$/, '<script>keep_polling=false</script>')
        if request.xhr?
          render :text => @results and return
        end
          
      else
        redirect_to root_url and return
      end
    end

  end

  def logs
    @logs = current_district.logs
  end

private
  def state_admin?
    unless current_district.admin?
      flash[:notice] = 'You do not have access to this action'
      redirect_to root_url
    end
  end
end
