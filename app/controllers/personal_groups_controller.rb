class PersonalGroupsController < ApplicationController
  # GET /personal_groups
  # GET /personal_groups.xml
  def index
    @personal_groups = current_user.personal_groups.by_school(current_school)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @personal_groups }
    end
  end

  # GET /personal_groups/new
  # GET /personal_groups/new.xml
  def new
    @personal_group = PersonalGroup.new
    @students = Student.find_all_by_id(selected_students_ids.collect(&:to_i))

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @personal_group }
    end
  end

  # GET /personal_groups/1/edit
  def edit
    @personal_group = current_user.personal_groups.find(params[:id])
    @students = Student.find_all_by_id(selected_students_ids.collect(&:to_i) | @personal_group.student_ids)
  end

  # POST /personal_groups
  # POST /personal_groups.xml
  def create
    @personal_group = current_user.personal_groups.new(params[:personal_group])
    @personal_group.school = current_school

    respond_to do |format|
      if @personal_group.save
        flash[:notice] = 'PersonalGroup was successfully created.'
        format.html { redirect_to(personal_groups_url) }
        format.xml  { render :xml => @personal_group, :status => :created, :location => @personal_group }
      else
        flash[:notice] = ''
        @students = Student.find_all_by_id(selected_students_ids.collect(&:to_i))
        format.html { render :action => "new" }
        format.xml  { render :xml => @personal_group.errors, :status => :unprocessable_entity }
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
        flash[:notice] = 'PersonalGroup was successfully updated.'
        format.html { redirect_to(personal_groups_url) }
        format.xml  { head :ok }
      else
        flash[:notice] = ''
        @students = Student.find_all_by_id(selected_students_ids.collect(&:to_i) | @personal_group.student_ids)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @personal_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /personal_groups/1
  # DELETE /personal_groups/1.xml
  def destroy
    @personal_group = current_user.personal_groups.find(params[:id])
    @personal_group.destroy

    respond_to do |format|
      format.html { redirect_to(personal_groups_url) }
      format.xml  { head :ok }
    end
  end
end
