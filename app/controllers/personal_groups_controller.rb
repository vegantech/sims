class PersonalGroupsController < ApplicationController
  # GET /personal_groups
  # GET /personal_groups.xml
  def index
    @personal_groups = PersonalGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @personal_groups }
    end
  end

  # GET /personal_groups/1
  # GET /personal_groups/1.xml
  def show
    @personal_group = PersonalGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @personal_group }
    end
  end

  # GET /personal_groups/new
  # GET /personal_groups/new.xml
  def new
    @personal_group = PersonalGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @personal_group }
    end
  end

  # GET /personal_groups/1/edit
  def edit
    @personal_group = PersonalGroup.find(params[:id])
  end

  # POST /personal_groups
  # POST /personal_groups.xml
  def create
    @personal_group = PersonalGroup.new(params[:personal_group])

    respond_to do |format|
      if @personal_group.save
        flash[:notice] = 'PersonalGroup was successfully created.'
        format.html { redirect_to(@personal_group) }
        format.xml  { render :xml => @personal_group, :status => :created, :location => @personal_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @personal_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /personal_groups/1
  # PUT /personal_groups/1.xml
  def update
    @personal_group = PersonalGroup.find(params[:id])

    respond_to do |format|
      if @personal_group.update_attributes(params[:personal_group])
        flash[:notice] = 'PersonalGroup was successfully updated.'
        format.html { redirect_to(@personal_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @personal_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /personal_groups/1
  # DELETE /personal_groups/1.xml
  def destroy
    @personal_group = PersonalGroup.find(params[:id])
    @personal_group.destroy

    respond_to do |format|
      format.html { redirect_to(personal_groups_url) }
      format.xml  { head :ok }
    end
  end
end
