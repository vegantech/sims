class AdminEmails
    ADMIN_MASK = 7
  def self.get
    users=User.find(:all, :conditions => "roles_mask & #{ADMIN_MASK} > 0 and email is not null and email !='tbiever@cesa6.k12.wi.us'", :include => :district)
    users.reject!{|e| e.last_login.nil? || e.email.blank?}
    output= CSV.generate do |csv|
      csv << ["district","email", "first name", "last name", "lsa", "content admin", "school admin", "last login"]
    users.each {|u|
      csv << [u.district.to_s,u.email, u.first_name, u.last_name,u.roles.include?("local_system_administrator"),u.roles.include?("content_admin"),u.roles.include?("school_admin"), u.last_login.to_date]
    }
    end
    puts output
  end
end
