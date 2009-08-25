class ScriptedController < ApplicationController
  skip_before_filter  :authorize, :verify_authenticity_token
  
  def referral_report
    require 'fastercsv'
    response.headers["Content-Type"]        = "text/csv; charset=UTF-8; header=present"
    response.headers["Content-Disposition"] = "attachment; filename=referrals.csv"
     
    @students = Student.connection.select_all("select s.id_district,r.id, r.created_at from students s left outer join recommendations r on r.student_id = s.id and r.promoted=true and r.recommendation=5  where s.district_id = #{current_district.id}")

    csv_string = FasterCSV.generate(:row_sep=>"\r\n") do |csv|
      csv << ["personID","referral_request","main_concerns","interventions_tried","family_involvement","external_factors","date"]
      @students.each do |student|
        if student["id"]
           
           answers = ActiveRecord::Base.connection.select_rows("select position, ra.text from recommendation_answers ra inner join recommendation_answer_definitions rad on ra.recommendation_answer_definition_id = rad.id  and ra.recommendation_id where ra.recommendation_id = #{student["id"]}").flatten 
           answers.each do |string|
             string.gsub! "\342\200\230", "'"
             string.gsub! "\342\200\231", "'"
             string.gsub! "\342\200\234", '"'
             string.gsub! "\342\200\235", '"'
           end
           
          answers = Hash[*answers]
          csv <<[student["id_district"],"Y",answers["1"],answers["2"],answers["3"],answers["4"], student["created_at"].to_date] 
        else
          csv << [student["id_district"],"N",nil,nil,nil,nil,nil]
        end
      end
    end
    send_data(csv_string,
       :type => 'text/csv; charset=utf-8; header=present',
       :filename => "referrals.csv"
       )
       
  end
             
      

  def district_upload
    if request.post? or true
      #curl --user foo:bar -Fupload_file=@x.c http://localhost:3333/scripted/district_upload?district_abbrev=mmsd
      #      render :text => "#{params.inspect} #{current_district.to_s}"
      spawn do
        importer = ImportCSV.new params[:upload_file], current_district
        importer.import
        Notifications.deliver_district_upload_results importer.messages, 'b723176@madison.k12.wi.us'
      end
      render :text=> ''
    else
      raise 'error'
    end
  end


protected
  def authenticate
    subdomains
    authenticate_or_request_with_http_basic do |username, password|
      username == params[:action] && current_district.users.authenticate(username,password)
    end
  end


  def bulk_import
    Spawn::method :yield, 'test'

    if request.post?
      spawn do
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
