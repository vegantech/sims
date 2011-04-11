class BehaviorReferralsController < ApplicationController
  # GET /behavior_referrals
  # GET /behavior_referrals.xml
  #
  # check and confirm school
  def index
    @school = School.find(params[:school_id])

    @behavior_referrals = @school.behavior_referrals

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @behavior_referrals }
    end
  end

  # GET /behavior_referrals/1
  # GET /behavior_referrals/1.xml
  def show
    @behavior_referral = BehaviorReferral.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @behavior_referral }
    end
  end

  # GET /behavior_referrals/new
  # GET /behavior_referrals/new.xml
  def new
    @school = School.find(params[:school_id])
    @behavior_referral = @school.behavior_referrals.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @behavior_referral }
    end
  end

  # GET /behavior_referrals/1/edit
  def edit
    @behavior_referral = BehaviorReferral.find(params[:id])
  end

  # POST /behavior_referrals
  # POST /behavior_referrals.xml
  def create
    @behavior_referral = BehaviorReferral.new(params[:behavior_referral])

    respond_to do |format|
      if @behavior_referral.save
        flash[:notice] = 'BehaviorReferral was successfully created.'
        format.html { redirect_to(@behavior_referral) }
        format.xml  { render :xml => @behavior_referral, :status => :created, :location => @behavior_referral }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @behavior_referral.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /behavior_referrals/1
  # PUT /behavior_referrals/1.xml
  def update
    @behavior_referral = BehaviorReferral.find(params[:id])

    respond_to do |format|
      if @behavior_referral.update_attributes(params[:behavior_referral])
        flash[:notice] = 'BehaviorReferral was successfully updated.'
        format.html { redirect_to(@behavior_referral) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @behavior_referral.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /behavior_referrals/1
  # DELETE /behavior_referrals/1.xml
  def destroy
    @behavior_referral = BehaviorReferral.find(params[:id])
    @behavior_referral.destroy

    respond_to do |format|
      format.html { redirect_to(behavior_referrals_url) }
      format.xml  { head :ok }
    end
  end
end
