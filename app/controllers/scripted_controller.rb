class ScriptedController < ApplicationController
  skip_before_filter  :authorize, :verify_authenticity_token
  
  def referral_report
    require 'fastercsv'
    response.headers["Content-Type"]        = "text/csv; charset=UTF-8; header=present"
    response.headers["Content-Disposition"] = "attachment; filename=referrals.csv"
    
    @students= dates_of_sims_data
   
    csv_string = FasterCSV.generate(:row_sep=>"\r\n") do |csv|
      csv << ["personID","referral_request","main_concerns","interventions_tried","family_involvement","external_factors","date","schoolyear"]
      @students.each do |student|
        if student["id"]
           
           answers = ActiveRecord::Base.connection.select_rows("select position, ra.text from recommendation_answers ra inner join recommendation_answer_definitions rad on ra.recommendation_answer_definition_id = rad.id  and ra.recommendation_id where ra.recommendation_id = #{student["id"]}").flatten 
           answers.each do |string|
             string.gsub! /\342\200\230/m, "'"
             string.gsub! /\342\200\231/m, "'"
             string.gsub! /\342\200\234/m, '"'
             string.gsub! /\342\200\235/m, '"'
             string.gsub! /"/m, "''"
           end
           
          answers = Hash[*answers]
          csv <<[student["district_student_id"],"Y",answers["1"],answers["2"],answers["3"],answers["4"], student["created_at"].to_datetime.strftime("%m/%d/%Y"),nil] 
        else
          csv << [student["district_student_id"],"N",nil,nil,nil,nil,nil,student["schoolyear"]] unless student["district_student_id"].blank?
        end
      end
    end
    send_data(csv_string,
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
      spawn do
        importer = ImportCSV.new params[:upload_file], current_district
        importer.import
        Notifications.deliver_district_upload_results importer.messages, @u.email || 'sbalestracci@madison.k12.wi.us'
      end
      render :text=> ''
    else
      raise 'error'
    end
  end

  def automated_intervention
    if request.post? or true
      importer=AutomatedIntervention.new params[:upload_file], current_district
      render :text=>importer.import
    else
      render :text =>"You need to POST a csv file with the following format:\n #{::AutomatedIntervention::FORMAT}"
    end
  end


protected
  def authenticate
    subdomains
    authenticate_or_request_with_http_basic do |username, password|
      username == params[:action] && @u=current_district.users.authenticate(username,password)
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

  def dates_of_sims_data


    referrals= Student.connection.select_all("select distinct s.district_student_id,r.id, r.created_at, (year(r.updated_at + INTERVAL 6 month))  as schoolyear
    from students s inner join recommendations r on r.student_id = s.id and r.promoted=true and r.recommendation=5 
    where s.district_id = #{current_district.id}")

    students =Student.connection.select_all(
 
    "
    select s.district_student_id,  (year(sc.updated_at + INTERVAL 6 month))  as schoolyear from student_comments sc
    inner join students s on sc.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(sc.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from recommendations r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union
    
    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from interventions r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from checklists r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from flags r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id} and r.type = 'CustomFlag'
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from principal_overrides r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from consultation_form_requests r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))

    union

    select s.district_student_id,  (year(r.updated_at + INTERVAL 6 month))  as schoolyear from consultation_forms r
    inner join students s on r.student_id = s.id
    where s.district_id = #{current_district.id}
    group by district_student_id, (year(r.updated_at + INTERVAL 6 month))
    ")

    students.reject! do |e|
      referrals.any? do |r|
        r["district_student_id"] == e["district_student_id"] &&
          r["schoolyear"] == e["schoolyear"]
      end
    end


    referrals + students
  end


  
end
