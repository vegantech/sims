class GroupsController < ApplicationController
  additional_read_actions :show_special
  additional_write_actions :add_student_form, :add_student, :remove_student, :add_user_form, :add_user, :remove_user, :remove_special
  # GET /groups
  # GET /groups.xml
  def index
    
    @groups=current_school.groups.paged_by_title(params[:title],params[:page])
    @virtual_groups = current_school.virtual_groups

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


  def add_user_form
    @group = current_school.groups.find(params[:id])
    @users = current_school.users 
    @user_assignment = @group.user_group_assignments.build
    #need to handle special user groups as well
    respond_to do |format|
      format.js {}
    end

  end

  def add_user
    #need to handle special user groups as well
   @group = current_school.groups.find(params[:id])

   @user_assignment = @group.user_group_assignments.build(params[:user_group_assignment])
   respond_to do |format|
     if @user_assignment.save
       format.js {}
     else
       @users = current_school.users 
       format.js {render :action=>"add_user_form"}
     end
   end
end

  def remove_user
    #need to handle special user groups as well
    @group = current_school.groups.find(params[:id])
    @user_assignment = @group.user_group_assignments.find(params[:user_assignment_id])
#    @user_assignment.destroy
  end

  def show_special
    @group=params[:id].titleize
    grade = @group.split(" ").last
    grade= nil if grade == "School"
    @special_user_groups = current_school.special_user_groups.find_all_by_grade(grade)
  end

  def remove_special
    @group = current_school.special_user_groups.find(params[:id])
    @group.destroy
    respond_to do |format|
      format.js {}
    end
  end
end
