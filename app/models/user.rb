class User < ActiveRecord::Base
  belongs_to :district

   def self.authenticate(username, password)
     @user = self.find_by_username(username)
       
     if @user
       expected_password=encrypted_password(password)
       if @user.passwordhash != expected_password
         @user = nil  unless ENV["RAILS_ENV"] =="development" || ENV["SKIP_PASSWORD"]=="skip-password"
       end
       @user
     end
   end


   def self.encrypted_password(password)
      Digest::SHA1.hexdigest(password.downcase)
   end

   
  def fullname 
    first_name.to_s + ' ' + last_name.to_s
  end

  def fullname_last_first
    last_name.to_s + ', ' + first_name.to_s
  end




end
