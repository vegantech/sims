class TeamAgendasController < ApplicationController
  skip_before_filter :authorize
  in_place_edit_for :other
  # GET /team_agendas
  # GET /team_agendas.xml
  def index
    @team_agendas = TeamAgenda.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @team_agendas }
    end
  end

  # GET /team_agendas/1
  # GET /team_agendas/1.xml
  def show
    @team_agenda = TeamAgenda.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team_agenda }
    end
  end

  # GET /team_agendas/new
  # GET /team_agendas/new.xml
  def new
    @team_agenda = TeamAgenda.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team_agenda }
    end
  end

  # GET /team_agendas/1/edit
  def edit
    @team_agenda = TeamAgenda.find(params[:id])
  end

  # POST /team_agendas
  # POST /team_agendas.xml
  def create
    @team_agenda = TeamAgenda.new(params[:team_agenda])

    respond_to do |format|
      if @team_agenda.save
        flash[:notice] = 'TeamAgenda was successfully created.'
        format.html { redirect_to(@team_agenda) }
        format.xml  { render :xml => @team_agenda, :status => :created, :location => @team_agenda }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team_agenda.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /team_agendas/1
  # PUT /team_agendas/1.xml
  def update
    @team_agenda = TeamAgenda.find(params[:id])

    respond_to do |format|
      if @team_agenda.update_attributes(params[:team_agenda])
        flash[:notice] = 'TeamAgenda was successfully updated.'
        format.html { redirect_to(@team_agenda) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team_agenda.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /team_agendas/1
  # DELETE /team_agendas/1.xml
  def destroy
    @team_agenda = TeamAgenda.find(params[:id])
    @team_agenda.destroy

    respond_to do |format|
      format.html { redirect_to(team_agendas_url) }
      format.xml  { head :ok }
    end
  end
end
