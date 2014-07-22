class StudentCommentsController < ApplicationController
  # GET /student_comments
  before_filter :check_student

  # GET /student_comments/new
  def new
    @student_comment = @student.comments.build
  end

  # GET /student_comments/1/edit
  def edit
    @student_comment = current_user.student_comments.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /student_comments
  def create
    @student_comment = @student.comments.build(params[:student_comment])
    @student_comment.user = current_user

    respond_to do |format|
      if @student_comment.save
        format.html {
           flash[:notice] = 'Team Note was successfully created.'
          redirect_to(@student)
         }
        format.js {responds_to_parent {render}}
      else
        format.html { render action: "new" }
        format.js { responds_to_parent{render action: "new" } }
      end
    end
  end

  # PUT /student_comments/1
  def update
    @student_comment = current_user.student_comments.find(params[:id])

    respond_to do |format|
      if @student_comment.update_attributes(params[:student_comment])
        format.html {
          flash[:notice] = 'Team Note was successfully updated.'
          redirect_to(@student)
        }
        format.js {responds_to_parent {render}}
      else
        format.html { render action: "edit" }
        format.js   { responds_to_parent{render action: "edit" } }
      end
    end
  end

  # DELETE /student_comments/1
  def destroy
    @student_comment = current_user.student_comments.find(params[:id])
    @student_comment.destroy

    respond_to do |format|
      format.html { redirect_to(@student) }
      format.js
    end
  end
end
