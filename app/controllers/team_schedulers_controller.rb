class TeamSchedulersController < ApplicationController
  # GET /team_schedulers
  # GET /team_schedulers.xml
  def index
    @team_schedulers = TeamScheduler.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @team_schedulers }
    end
  end

  # GET /team_schedulers/1
  # GET /team_schedulers/1.xml
  def show
    @team_scheduler = TeamScheduler.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team_scheduler }
    end
  end

  # GET /team_schedulers/new
  # GET /team_schedulers/new.xml
  def new
    @team_scheduler = TeamScheduler.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team_scheduler }
    end
  end

  # GET /team_schedulers/1/edit
  def edit
    @team_scheduler = TeamScheduler.find(params[:id])
  end

  # POST /team_schedulers
  # POST /team_schedulers.xml
  def create
    @team_scheduler = TeamScheduler.new(params[:team_scheduler])

    respond_to do |format|
      if @team_scheduler.save
        flash[:notice] = 'TeamScheduler was successfully created.'
        format.html { redirect_to(@team_scheduler) }
        format.xml  { render :xml => @team_scheduler, :status => :created, :location => @team_scheduler }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team_scheduler.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /team_schedulers/1
  # PUT /team_schedulers/1.xml
  def update
    @team_scheduler = TeamScheduler.find(params[:id])

    respond_to do |format|
      if @team_scheduler.update_attributes(params[:team_scheduler])
        flash[:notice] = 'TeamScheduler was successfully updated.'
        format.html { redirect_to(@team_scheduler) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team_scheduler.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /team_schedulers/1
  # DELETE /team_schedulers/1.xml
  def destroy
    @team_scheduler = TeamScheduler.find(params[:id])
    @team_scheduler.destroy

    respond_to do |format|
      format.html { redirect_to(team_schedulers_url) }
      format.xml  { head :ok }
    end
  end
end
