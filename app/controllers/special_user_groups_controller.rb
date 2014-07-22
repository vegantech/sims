class SpecialUserGroupsController < SchoolAdminController
  def show
    # TODO push group search to model
    @group=params[:id]
    grade = @group.split("-").last.downcase
    grade= nil if grade == "school"
    @special_user_groups = current_school.special_user_groups.find_all_by_grade(grade)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /groups/1/edit
  def edit
    @group=params[:id]
    grade = @group.split("-").last.downcase
    grade= nil if grade == "school"
    @special_user_group = current_school.special_user_groups.build(grade: grade)
    @users = current_school.assigned_users
  end

  # POST /groups
  def create
    @special_user_group = current_school.special_user_groups.build(params[:special_user_group])
    @group = @special_user_group.title.parameterize
    if @special_user_group.save
    else
      @users=current_school.assigned_users
      render action: :edit
    end
  end

  # PUT /groups/1
  # DELETE /groups/1
  def destroy
    @group = current_school.special_user_groups.find(params[:id])
    @group.destroy
    respond_to do |format|
      format.js {}
    end
  end
end
