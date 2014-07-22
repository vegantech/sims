class Groups::UsersController < Groups::AssignmentsController
  def new
    @users = current_school.assigned_users
    @user_assignment = @group.user_group_assignments.build
    # need to handle special user groups as well
    respond_to do |format|
      format.js {}
    end
  end

  def create
    @user_assignment = @group.user_group_assignments.build(params[:user_group_assignment])
    respond_to do |format|
      if @user_assignment.save
        format.js {}
      else
        @users = current_school.assigned_users
        format.js {render action: "new"}
      end
    end
  end

  def destroy
    @user_assignment = @group.user_group_assignments.find(params[:id])
    @user_assignment.destroy
    respond_to do |format|
      format.html {redirect_to @group}
      format.js {}

    end
  end
end
