# == Schema Information
# Schema version: 20101101011500
#
# Table name: consultation_form_requests
#
#  id                          :integer(4)      not null, primary key
#  student_id                  :integer(4)
#  requestor_id                :integer(4)
#  team_id                     :integer(4)
#  all_student_scheduled_staff :boolean(1)
#  created_at                  :datetime
#  updated_at                  :datetime
#

class ConsultationFormRequest < ActiveRecord::Base
  DISTRICT_PARENT = :school_team
  belongs_to :student, :touch => true
  belongs_to :requestor, :class_name => 'User'
  belongs_to :school_team, :foreign_key => 'team_id'

  validates_presence_of :user_ids, :if => proc{|e| e.whom.include? 'other' or e.whom.blank?}
  after_create :email_requests
  before_create :assign_team

  attr_accessor :user_ids

  def whom
    if @whom
      @whom
    else
      w = []
      w << 'all_staff_for_student' if all_student_scheduled_staff?
      w << 'predetermined_teams' if school_team.present? && !school_team.anonymous? && !new_record?
      w << 'other' if school_team.present? && school_team.anonymous?
      @whom = w
    end
  end

  def whom=(target)
    @whom=target
  end

  private

  def email_requests
    get_recipients
    TeamReferrals.gather_information_request(@recipients, student, requestor).deliver if @recipients
  end

  def get_recipients

    @recipients = []
    @recipients |= student.all_staff_for_student if all_student_scheduled_staff
    @recipients |= school_team.users if school_team

  end

  def assign_team
    self.all_student_scheduled_staff =  @whom.include?('all_staff_for_student')
    self.team_id = nil unless (@whom.include?('predetermined_teams') || @whom.blank?)

    if @whom.include?('other') && @user_ids.present?
        @user_ids |= school_team.user_ids if school_team
        self.team_id=nil
        create_school_team(:anonymous=>true,:user_ids=>@user_ids)
    end
  end
end

