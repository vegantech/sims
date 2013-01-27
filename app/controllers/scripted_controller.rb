class ScriptedController < ApplicationController
  skip_before_filter  :authorize, :verify_authenticity_token
  def referral_report
    response.headers["Content-Type"]        = "text/csv; charset=UTF-8; header=present"
    response.headers["Content-Disposition"] = "attachment; filename=referrals.csv"

    send_data(ReferralReport.csv(current_district),
       :type => 'text/csv; charset=utf-8; header=present',
       :filename => "referrals.csv"
       )
  end

  def district_export
    send_file(DistrictExport.generate(current_district), :x_sendfile => true, :filename => 'sims_export.zip')
  end

  def district_upload
    if request.post?
      #curl --user foo:bar -Fupload_file=@x.c http://localhost:3333/scripted/district_upload?district_abbrev=mmsd
      #      render :text => "#{params.inspect} #{current_district.to_s}"
      spawn_block do
        importer = ImportCSV.new params[:upload_file], current_district
        importer.import
        Notifications.district_upload_results(importer.messages, @u.email || 'sbalestracci@madison.k12.wi.us').deliver
      end
      render :text=> ''
    else
      raise 'error'
    end
  end

  def automated_intervention
    if request.post?
      spawn_block(:method => :yield) do
        importer=AutomatedIntervention.new params[:upload_file], @u
        @messages=importer.import
        Notifications.district_upload_results( @messages, @u.email || 'sbalestracci@madison.k12.wi.us').deliver
      end
        render :text=>"response will be emailed to #{@u.email}" and return
    end
    render :layout=>false
  end


protected
  def authenticate_user!
    authenticate_or_request_with_http_basic do |username, password|
      username == params[:action] && @u=current_district.users.find_by_username(username) and @u.try(:valid_password?,password)
    end
  end

  def current_district
    @current_district ||= District.find_by_subdomain(params[:district_abbrev].presence || current_subdomain.presence)
  end


  def bulk_import

    if request.post?
      spawn_block do
        importer= ImportCSV.new params[:import_file], current_district
        x=Benchmark.measure{importer.import}

        @results = "#{importer.messages.join(", ")} #{x}"
        #request redirect_to root_url
      end
      render :layout => false
    else
      raise 'needs to be a post'
    end

  end
end
