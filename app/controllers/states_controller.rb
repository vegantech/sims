class StatesController < ApplicationController
  additional_write_actions :reset_password, :recreate_admin
  # GET /states
  def index
    @country = current_district.country
    @states = @country.states.normal

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /states/new
  def new
    @state = State.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /states/1/edit
  def edit
    @state = current_district.state
  end

  # POST /states
  def create
    @state = current_district.country.states.build(params[:state])

    respond_to do |format|
      if @state.save
        flash[:notice] = 'State was successfully created.'
        format.html { redirect_to(states_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /states/1
  def update
    @state = current_district.state
    

    respond_to do |format|
      if @state.update_attributes(params[:state])
        flash[:notice] = 'State was successfully updated.'
        format.html { redirect_to(root_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /states/1
  def destroy
    @state = current_district.country.states.find(params[:id])
    @state.destroy
    flash[:notice] = @state.errors[:base]


    respond_to do |format|
      format.html { redirect_to(states_url) }
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
