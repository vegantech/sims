class UsageByDistrict
  def self.usage start="2000-01-01".to_date, end_date = '2100-01-01'.to_date
    dhash =Hash.new { |h,k| h[k]={} }


    i1= Intervention.find(:all, :select => "districts.name, count(interventions.id) as interventions, count(distinct student_id) as students_with_interventions", 
                          :joins => {:student => :district}, :group => "districts.name", 
                          :conditions => "interventions.created_at between '#{start}' and '#{end_date}'")
    i2= StudentComment.find(:all, :select => "districts.name, count(student_comments.id) as team_notes, count(distinct student_id) as students_with_team_notes", 
                            :joins => {:student => :district}, :group => "districts.name", 
                            :conditions => "student_comments.created_at between '#{start}' and '#{end_date}'")
    i3= TeamConsultation.find(:all, 
                              :select => "districts.name, 
                              count(team_consultations.id) as team_consultations, count(distinct student_id) as students_with_team_consultations", 
                              :joins => {:student => :district}, :group => "districts.name", 
                              :conditions => "team_consultations.created_at between '#{start}' and '#{end_date}'")

    i4= DistrictLog.joins(:district).successful_login_non_admin.select('districts.name, count(distinct user_id) as users_who_have_logged_in, count(district_logs.id) as successful_logins').where("district_logs.created_at" => start..end_date).group("districts.name")

    [i1,i2,i3,i4].flatten.each {|i| dhash[i["name"]].merge!(i.attributes)}
    dhash.sort.each do |k,v|
      puts "#{v["name"]}: #{v.to_a[1..-1].collect{|k,v| "#{k} - #{v}"}.join(", ")}"
    end

    dhash




  end
end
