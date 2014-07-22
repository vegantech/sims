class CustomFlagsController < ApplicationController
  # GET /custom_flags
  # GET /custom_flags.xml
  before_filter :enforce_session_selections
  skip_before_filter :verify_authenticity_token

  def index
    @student = current_student
  end
  # GET /custom_flags/new
  # GET /custom_flags/new.xml
  def new
    @custom_flag = CustomFlag.new(student_id: current_student_id, user_id: current_user.id)
    respond_to do |format|
      format.html # new.html.erb
      format.js # new.js.rjs
    end
  end

  def create
    @custom_flag = CustomFlag.new(params[:custom_flag])

     respond_to do |format|
       if @custom_flag.save
         flash[:notice] = 'Custom Flag was successfully created.'
         format.html { redirect_to(current_student) }
         format.js   {  }
       else
         format.html { render action: "new" }
         format.js { render action: "new" }
       end
     end
   end

  # DELETE /custom_flags/1
  # DELETE /custom_flags/1.xml
  def destroy
    @custom_flag = current_student.custom_flags.find(params[:id])
    @custom_flag.destroy

    respond_to do |format|
      format.html { redirect_to(current_student) }
      format.js   {}
    end
  end

  def ignore_flag
    if params[:category] then
      @ignore_flag=current_student.ignore_flags.build(category: params[:category], user_id: current_user.id)
      respond_to do |format|
        format.html {render action: "_ignore_flag"}
        format.js
      end
    else
      @ignore_flag=current_student.ignore_flags.build(params[:ignore_flag].merge(user_id: current_user.id))
      @ignore_flag.save
      respond_to do |format|
        format.html do
          unless @ignore_flag.new_record?
            redirect_to student_url(current_student)
          else
            render action: "_ignore_flag"
          end
        end
        format.js
      end
    end
  end

  def unignore_flag
    @ignore_flag=current_student.ignore_flags.find(params[:id])
    @ignore_flag.destroy
    respond_to do |format|
      format.html {redirect_to student_url(current_student)}
      format.js
    end
  end

  private
  def enforce_session_selections
    # doesn't work.
    params[:student_id] = current_student_id
    params[:user_id] = current_user.id
  end
end
