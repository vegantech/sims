class GroupsController < ApplicationController
  additional_write_actions :add_student_form, :add_student, :remove_student
  # GET /groups
  # GET /groups.xml
 def index
    @groups=current_school.groups.paged_by_title(params[:title],params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = current_school.groups.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = current_school.groups.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = current_school.groups.build(params[:group])

    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to(@group) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = current_school.groups.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(@group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = current_school.groups.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end

  def remove_student
    @group = current_school.groups.find(params[:id])
    @student = @group.students.find(params[:student_id])
    @group.students.delete(@student)

    respond_to do |format|
      format.js {}
    end
  end

  def add_student_form
    @group = current_school.groups.find(params[:id])
    @student = Student.new
    @students=current_school.students - @group.students
    respond_to do |format|
      format.js {}
    end

  end

  def add_student
    @group = current_school.groups.find(params[:id])
    @student = current_school.students.find(params[:student][:id])
    @group.student_ids |= [@student.id]
    respond_to do |format|
      format.js {}
    end
  end
end
