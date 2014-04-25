class GroupsController < SchoolAdminController
  # GET /groups
  def index
    @groups = current_school.groups.paged_by_title(params[:title],params[:page])
    redirect_to(index_url_with_page(title: params[:title], page: @groups.total_pages)) and return if wp_out_of_bounds?(@groups)
    capture_paged_controller_params

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /groups/1
  def show
    @group = current_school.groups.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /groups/new
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /groups/1/edit
  def edit
    @group = current_school.groups.find(params[:id])
  end

  # POST /groups
  def create
    @group = current_school.groups.build(params[:group])

    respond_to do |format|
      if @group.save
        flash[:notice] = "#{edit_obj_link(@group)} was successfully created.".html_safe
        format.html { redirect_to(@group) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /groups/1
  def update
    @group = current_school.groups.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = "#{edit_obj_link(@group)} was successfully updated.".html_safe
        format.html { redirect_to(@group) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /groups/1
  def destroy
    @group = current_school.groups.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
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
    @students = current_school.students.order('last_name, first_name') - @group.students
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
    @users = current_school.assigned_users
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
       @users = current_school.assigned_users
       format.js {render action: "add_user_form"}
     end
   end
end

  def remove_user
    #need to handle special user groups as well
    @group = current_school.groups.find(params[:id])
    @user_assignment = @group.user_group_assignments.find(params[:user_assignment_id])
    @user_assignment.destroy
    respond_to do |format|
      format.html {redirect_to @group}
      format.js {}

    end
  end
end
