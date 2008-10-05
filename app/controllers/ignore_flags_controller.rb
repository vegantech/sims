class IgnoreFlagsController < ApplicationController
  # GET /ignore_flags
  # GET /ignore_flags.xml
  def index
    @ignore_flags = IgnoreFlag.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ignore_flags }
    end
  end

  # GET /ignore_flags/1
  # GET /ignore_flags/1.xml
  def show
    @ignore_flag = IgnoreFlag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ignore_flag }
    end
  end

  # GET /ignore_flags/new
  # GET /ignore_flags/new.xml
  def new
    @ignore_flag = IgnoreFlag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ignore_flag }
    end
  end

  # GET /ignore_flags/1/edit
  def edit
    @ignore_flag = IgnoreFlag.find(params[:id])
  end

  # POST /ignore_flags
  # POST /ignore_flags.xml
  def create
    @ignore_flag = IgnoreFlag.new(params[:ignore_flag])

    respond_to do |format|
      if @ignore_flag.save
        flash[:notice] = 'IgnoreFlag was successfully created.'
        format.html { redirect_to(@ignore_flag) }
        format.xml  { render :xml => @ignore_flag, :status => :created, :location => @ignore_flag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ignore_flag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ignore_flags/1
  # PUT /ignore_flags/1.xml
  def update
    @ignore_flag = IgnoreFlag.find(params[:id])

    respond_to do |format|
      if @ignore_flag.update_attributes(params[:ignore_flag])
        flash[:notice] = 'IgnoreFlag was successfully updated.'
        format.html { redirect_to(@ignore_flag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ignore_flag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ignore_flags/1
  # DELETE /ignore_flags/1.xml
  def destroy
    @ignore_flag = IgnoreFlag.find(params[:id])
    @ignore_flag.destroy

    respond_to do |format|
      format.html { redirect_to(ignore_flags_url) }
      format.xml  { head :ok }
    end
  end
end
