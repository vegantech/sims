class ScriptedController < ApplicationController
  skip_before_filter  :authorize
  
  def referral_report
    subdomains
    authenticate
    @students = Student.connection.select_all("select s.id_district,r.id, r.created_at from students s left outer join recommendations r on r.student_id = s.id and r.promoted=true and r.recommendation=5  where s.district_id = #{current_district.id}")
    
    render :layout => false
  end

  def district_upload
  end


protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
    username == "foo" && password == "bar"
    end
  end
  
end
