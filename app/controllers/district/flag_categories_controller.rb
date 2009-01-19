class District::FlagCategoriesController < ApplicationController
  # GET /district_flag_categories
  # GET /district_flag_categories.xml
  def index
    @flag_categories = current_district.flag_categories

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @flag_categories }
    end
  end

  # GET /district_flag_categories/1
  # GET /district_flag_categories/1.xml
  def show
    @flag_category = current_district.flag_categories.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @flag_category }
    end
  end

  # GET /district_flag_categories/new
  # GET /district_flag_categories/new.xml
  def new
    @flag_category = current_district.flag_categories.build
    @flag_category.assets.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @flag_category }
    end
  end

  # GET /district_flag_categories/1/edit
  def edit
    @flag_category = current_district.flag_categories.find(params[:id])
  end

  # POST /district_flag_categories
  # POST /district_flag_categories.xml
  def create
    @flag_category = current_district.flag_categories.build(params[:flag_category])

    respond_to do |format|
      if @flag_category.save
        flash[:notice] = 'FlagCategory was successfully created.'
        format.html { redirect_to(@flag_category) }
        format.xml  { render :xml => @flag_category, :status => :created, :location => @flag_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @flag_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /district_flag_categories/1
  # PUT /district_flag_categories/1.xml
  def update
    params[:flag_category][:existing_asset_attributes] ||= {}
    @flag_category = current_district.flag_categories.find(params[:id])

    respond_to do |format|
      if @flag_category.update_attributes(params[:flag_category])
        flash[:notice] = 'FlagCategory was successfully updated.'
        format.html { redirect_to(@flag_category) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @flag_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /district_flag_categories/1
  # DELETE /district_flag_categories/1.xml
  def destroy
    @flag_category = current_district.flag_categories.find(params[:id])
    @flag_category.destroy

    respond_to do |format|
      format.html { redirect_to(flag_categories_url) }
      format.xml  { head :ok }
    end
  end
end
