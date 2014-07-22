class IgnoreFlagsController < ApplicationController
  before_filter :enforce_session_selections
  skip_before_filter :verify_authenticity_token

  def new
    @ignore_flag=current_student.ignore_flags.build(:category=>params[:category], :user_id => current_user.id)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @ignore_flag=current_student.ignore_flags.build(params[:ignore_flag].merge(:user_id=>current_user.id))
    if @ignore_flag.save
      respond_to do |format|
        format.html { redirect_to student_url(current_student)}
        format.js
      end
    else
      render :new and return
    end
  end

  def destroy
    @ignore_flag=current_student.ignore_flags.find(params[:id])
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
    params[:user_id] = current_user.id
  end
end
