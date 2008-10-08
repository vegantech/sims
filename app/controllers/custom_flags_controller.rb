class CustomFlagsController < ApplicationController
  # GET /custom_flags
  # GET /custom_flags.xml
  before_filter :enforce_session_selections

  def index
    @custom_flags = CustomFlag.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @custom_flags }
    end
  end

  # GET /custom_flags/1
  # GET /custom_flags/1.xml
  def show
    @custom_flag = CustomFlag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @custom_flag }
    end
  end

  # GET /custom_flags/new
  # GET /custom_flags/new.xml
  def new
    @custom_flag = CustomFlag.new(:student_id=>current_student_id, :user_id=>current_user_id)


    respond_to do |format|
      format.js # new.js.rjs
      format.html # new.html.erb
      format.xml  { render :xml => @custom_flag }
    end
  end

  # GET /custom_flags/1/edit
  def edit
    @custom_flag = CustomFlag.find(params[:id])
  end

  # POST /custom_flags
  # POST /custom_flags.xml
  def create
    @custom_flag = CustomFlag.new(params[:custom_flag])

    respond_to do |format|
      if @custom_flag.save
        flash[:notice] = 'CustomFlag was successfully created.'
        format.html { redirect_to(current_student) }
        format.js   {  }
        format.xml  { render :xml => @custom_flag, :status => :created, :location => @custom_flag }
      else
        format.html { render :action => "new" }
        format.js { render :action=> "new" }
        format.xml  { render :xml => @custom_flag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /custom_flags/1
  # PUT /custom_flags/1.xml
  def update
    @custom_flag = CustomFlag.find(params[:id])

    respond_to do |format|
      if @custom_flag.update_attributes(params[:custom_flag])
        flash[:notice] = 'CustomFlag was successfully updated.'
        format.html { redirect_to(@custom_flag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @custom_flag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_flags/1
  # DELETE /custom_flags/1.xml
  def destroy
    @custom_flag = CustomFlag.find(params[:id])
    @custom_flag.destroy if selected_students_ids.include?(@custom_flag.student_id)

    respond_to do |format|
      format.html { redirect_to(current_student) }
      format.js   {}
      format.xml  { head :ok }
    end
  end

  def enforce_session_selections
    params[:student_id] = current_student_id
    params[:user_id] = current_user_id
  end


end
