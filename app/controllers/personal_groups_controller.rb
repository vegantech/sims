class PersonalGroupsController < ApplicationController
  # GET /personal_groups
  # GET /personal_groups.xml
  def index
    @personal_groups = current_user.personal_groups.by_school(current_school)
  end

  # GET /personal_groups/new
  # GET /personal_groups/new.xml
  def new
    flash[:notice]="You must select students before you can create a new personal group" and redirect_to students_url and return if selected_student_ids.blank?
    @personal_group = PersonalGroup.new
    @students = Student.find_all_by_id(selected_student_ids.collect(&:to_i))
  end

  # GET /personal_groups/1/edit
  def edit
    flash[:notice]="You must select students before you can edit a personal group" and redirect_to students_url and return if selected_student_ids.blank?
    @personal_group = current_user.personal_groups.find(params[:id])
    @students = Student.find_all_by_id(selected_student_ids.collect(&:to_i) | @personal_group.student_ids)
  end

  # POST /personal_groups
  # POST /personal_groups.xml
  def create
    @personal_group = current_user.personal_groups.new(params[:personal_group])
    @personal_group.school = current_school

    respond_to do |format|
      if @personal_group.save
        flash[:notice] = "The #{@personal_group.name} group is now available in the student search screen."
        format.html { redirect_to(personal_groups_url) }
      else
        @students = Student.find_all_by_id(selected_student_ids.collect(&:to_i))
        format.html { render action: "new" }
      end
    end
  end

  # PUT /personal_groups/1
  # PUT /personal_groups/1.xml
  def update
    @personal_group = current_user.personal_groups.find(params[:id])
    params[:personal_group][:student_ids] ||= []

    respond_to do |format|
      if @personal_group.update_attributes(params[:personal_group])
        flash[:notice] = "The students in the #{@personal_group.name} group have been updated. If you've changed students and want to work with all students in this group you will need to go back to the student search screen and select the group and select the students on the next screen."
        format.html { redirect_to(personal_groups_url) }
      else
        @students = Student.find_all_by_id(selected_student_ids.collect(&:to_i) | @personal_group.student_ids)
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /personal_groups/1
  # DELETE /personal_groups/1.xml
  def destroy
    @personal_group = current_user.personal_groups.find(params[:id])
    @personal_group.destroy
    redirect_to(personal_groups_url)
  end
end
