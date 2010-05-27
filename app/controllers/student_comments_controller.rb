class StudentCommentsController < ApplicationController
  # GET /student_comments
  # GET /student_comments.xml
  before_filter :enforce_session_selections

  # GET /student_comments/new
  # GET /student_comments/new.xml
  def new
    @student_comment = StudentComment.new(:student_id=>current_student_id, :user_id=>current_user_id)

    respond_to do |format|
      format.js 
      format.html # new.html.erb
      format.xml  { render :xml => @student_comment }
    end
  end

  # GET /student_comments/1/edit
  def edit
    @student_comment = current_user.student_comments.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  # POST /student_comments
  # POST /student_comments.xml
  def create
    @student_comment = StudentComment.new(params[:student_comment])
    
    
    respond_to do |format|
      if @student_comment.save
        format.js {responds_to_parent {render}}
        format.html { 
          flash[:notice] = 'Team Note was successfully created.'
          redirect_to(current_student) 
         }
        format.xml  { render :xml => @student_comment, :status => :created, :location => @student_comment }
      else
        format.js { responds_to_parent{render :action => "new" } }
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /student_comments/1
  # PUT /student_comments/1.xml
  def update
    @student_comment = current_user.student_comments.find(params[:id])
    @student_comment.body=params[:student_comment][:body]
    
    respond_to do |format|
      if @student_comment.save
        flash[:notice] = 'Team Note was successfully updated.'
        format.js {responds_to_parent {render}}
        format.html { redirect_to(current_student) }
        format.xml  { head :ok }
      else
        format.js   { responds_to_parent{render :action => "edit" } }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /student_comments/1
  # DELETE /student_comments/1.xml
  def destroy
    @student_comment = current_user.student_comments.find(params[:id])
    @student_comment.destroy 

    respond_to do |format|
      format.js
      format.html { redirect_to(current_student) }
      format.xml  { head :ok }
    end
  end


  private
  def enforce_session_selections
    params[:student_id] = current_student_id
    params[:user_id] = current_user_id
  end



end
