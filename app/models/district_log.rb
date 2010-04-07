class DistrictLog < ActiveRecord::Base
  belongs_to :district

  named_scope :successful_login, :conditions => ["body like ?","Successful login%"]
  named_scope :failed_login, :conditions => ["body like ?","Failed login%"]
  

  define_statistic :successful_logins, :count => [:successful_login]
  define_statistic :failed_logins, :count => :failed_login
  define_statistic :first_recorded_login, :minimum => :all, :column_name => ['created_at']
  define_statistic :districts_with_successful_login, :count => :successful_login, :select => 'distinct district_id'
  define_statistic :users_that_have_logged_in, :count => :successful_login, :select => 'distinct district_id,body' 


  def to_s
    "#{created_at}- #{body}"
  end
end
