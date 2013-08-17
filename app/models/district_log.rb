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
  include Pageable
  belongs_to :district
  belongs_to :user
  SUCCESS =0
  FAILURE =1

#  attr_protected :district_id

  scope :success, where(:status => SUCCESS)
  scope :successful_login_non_admin,  success.joins(:user).merge(User.non_admin)
  scope :failure, where(:status => FAILURE)

  define_statistic :successful_logins, :count => [:success]
  define_statistic :failed_logins, :count => :failure
  define_statistic :first_recorded_login, :minimum => :all, :column_name => 'created_at'
  define_statistic :districts_with_successful_login, :count => :success, :column_name => 'distinct district_logs.district_id'
  define_statistic :users_that_have_logged_in, :count => :success, :column_name => 'distinct user_id'
  define_statistic :non_admin_users_that_have_logged_in, :count => :successful_login_non_admin, :column_name => 'distinct user_id'
  define_statistic :districts_with_successful_non_admins, :count => :successful_login_non_admin, :column_name => 'distinct district_logs.district_id'


  def to_s
    if status == SUCCESS
      if user
        "#{created_at}- Successful login of #{user.to_s}"
      else
        "#{created_at}- #{body}"
      end
    elsif status == FAILURE
      "#{created_at}- Failed login of #{body}"
    end
  end

  def self.record_failure(params)
    logger.info "Failed login of #{params["username"]} at #{ params["district_id_for_login"]}"
    failure.create!(:district_id => params["district_id_for_login"], :body =>  params["username"])
  end

  def self.record_success(user)
    logger.info "Successful login of #{user.fullname} at #{user.district.name}"
    success.create!(:district_id => user.district_id, :user => user)
  end

end
