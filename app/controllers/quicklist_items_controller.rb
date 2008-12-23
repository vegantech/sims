class QuicklistItemsController < ApplicationController
  # GET /quicklist_items
  # GET /quicklist_items.xml
  def index
    @quicklist_items = QuicklistItem.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quicklist_items }
    end
  end

  # GET /quicklist_items/1
  # GET /quicklist_items/1.xml
  def show
    @quicklist_item = QuicklistItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quicklist_item }
    end
  end

  # GET /quicklist_items/new
  # GET /quicklist_items/new.xml
  def new
    @quicklist_item = QuicklistItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @quicklist_item }
    end
  end

  # GET /quicklist_items/1/edit
  def edit
    @quicklist_item = QuicklistItem.find(params[:id])
  end

  # POST /quicklist_items
  # POST /quicklist_items.xml
  def create
    @quicklist_item = QuicklistItem.new(params[:quicklist_item])

    respond_to do |format|
      if @quicklist_item.save
        flash[:notice] = 'QuicklistItem was successfully created.'
        format.html { redirect_to(@quicklist_item) }
        format.xml  { render :xml => @quicklist_item, :status => :created, :location => @quicklist_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quicklist_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /quicklist_items/1
  # PUT /quicklist_items/1.xml
  def update
    @quicklist_item = QuicklistItem.find(params[:id])

    respond_to do |format|
      if @quicklist_item.update_attributes(params[:quicklist_item])
        flash[:notice] = 'QuicklistItem was successfully updated.'
        format.html { redirect_to(@quicklist_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quicklist_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /quicklist_items/1
  # DELETE /quicklist_items/1.xml
  def destroy
    @quicklist_item = QuicklistItem.find(params[:id])
    @quicklist_item.destroy

    respond_to do |format|
      format.html { redirect_to(quicklist_items_url) }
      format.xml  { head :ok }
    end
  end
end
