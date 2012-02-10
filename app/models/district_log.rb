# == Schema Information
# Schema version: 20101101011500
#
# Table name: district_logs
#
#  id          :integer(4)      not null, primary key
#  district_id :integer(4)
#  body        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class DistrictLog < ActiveRecord::Base
  belongs_to :district
  belongs_to :user
  attr_protected :district_id

  scope :successful_login, where( ["body like ?","Successful login%"])
  scope :failed_login, where(["body like ?","Failed login%"])
  scope :successful_login_non_admin,  where(["body like ? and body not like ? and body not like ?","Successful login%", "%Tammy Biever%", "%Administrator%"])

  define_statistic :successful_logins, :count => [:successful_login]
  define_statistic :failed_logins, :count => :failed_login
  define_statistic :first_recorded_login, :minimum => :all, :column_name => ['created_at']
  define_statistic :districts_with_successful_login, :count => :successful_login, :select => 'distinct district_id'
  define_statistic :users_that_have_logged_in, :count => :successful_login, :select => 'distinct district_id,body'
  define_statistic :non_admin_users_that_have_logged_in, :count => :successful_login_non_admin, :select => 'distinct district_id,body'
  define_statistic :districts_with_successful_non_admins, :count => :successful_login_non_admin, :select => 'distinct district_id'


  def to_s
    "#{created_at}- #{body}"
  end
end
