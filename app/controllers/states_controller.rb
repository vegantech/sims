class StatesController < ApplicationController
  additional_write_actions :reset_password, :recreate_admin
  # GET /states
  # GET /states.xml
  def index
    @country = current_district.country
    @states = @country.states.normal

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @states }
    end
  end

  # GET /states/new
  # GET /states/new.xml
  def new
    @state = State.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @state }
    end
  end

  # GET /states/1/edit
  def edit
    @state = current_district.state
  end

  # POST /states
  # POST /states.xml
  def create
    @state = current_district.country.states.build(params[:state])

    respond_to do |format|
      if @state.save
        flash[:notice] = 'State was successfully created.'
        format.html { redirect_to(states_url) }
        format.xml  { render :xml => @state, :status => :created, :location => @state }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /states/1
  # PUT /states/1.xml
  def update
    @state = current_district.state
    

    respond_to do |format|
      if @state.update_attributes(params[:state])
        flash[:notice] = 'State was successfully updated.'
        format.html { redirect_to(root_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /states/1
  # DELETE /states/1.xml
  def destroy
    @state = current_district.country.states.find(params[:id])
    @state.destroy
    flash[:notice] = @state.errors[:base]


    respond_to do |format|
      format.html { redirect_to(states_url) }
      format.xml  { head :ok }
    end
  end
  
  def reset_password
    @state=State.find(params[:id])
    flash[:notice]= @state.admin_district.reset_admin_password!
    redirect_to(states_url)
  end

  def recreate_admin
    @state=State.find(params[:id])
    flash[:notice]= @state.admin_district.recreate_admin!
    redirect_to(states_url)
  end
end
