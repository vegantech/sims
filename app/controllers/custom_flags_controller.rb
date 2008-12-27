class CustomFlagsController < ApplicationController
  # GET /custom_flags
  # GET /custom_flags.xml
  before_filter :enforce_session_selections
  additional_write_actions :ignore_flag, :unignore_flag

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


  def ignore_flag
    if params[:category] then
      @ignore_flag=current_student.ignore_flags.build(:category=>params[:category], :user_id => current_user_id)
      respond_to do |format|
        format.html {render :action=> "_ignore_flag"}
        format.js 
      end
    else
      @ignore_flag=current_student.ignore_flags.build(params[:ignore_flag].merge(:user_id=>current_user_id))
      @ignore_flag.save
      respond_to do |format|
        format.html do 
                      unless @ignore_flag.new_record?
                        redirect_to student_url(current_student)
                      else
                        render :action => "_ignore_flag"
                      end
                    end
        format.js 
      end
    end
  end

  def unignore_flag
    @ignore_flag=current_student.ignore_flags.find_by_id(params[:id]) || IgnoreFlag.new
    @ignore_flag.destroy
    respond_to do |format| 
      format.html {redirect_to student_url(current_student)}
      format.js
    end
  end
    
    

  
  private
  def enforce_session_selections
    #doesn't work.
    params[:student_id] = current_student_id
    params[:user_id] = current_user_id
  end

end
