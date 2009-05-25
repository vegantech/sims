class ConsultationFormRequest < ActiveRecord::Base
  belongs_to :student
  belongs_to :requestor, :class_name => 'User'
  belongs_to :school_team, :foreign_key => 'team_id'


  validates_presence_of :user_ids, :if => proc{|e| e.whom == 'other'}
  after_create :email_requests
  before_create :assign_team

  attr_accessor :user_ids

  def whom
    @whom ||= :all_staff_for_student
  end

  def whom=(target)
    @whom=target 
  end


  private

  def email_requests
    get_recipients
    TeamReferrals.deliver_gather_information_request(@recipients, student, requestor) if @recipients
  end


  def get_recipients
    case @whom
    when 'all_staff_for_student'
      @recipients = student.all_staff_for_student
    else
      @recipients = school_team.users if school_team
    end

  end

  def assign_team
    case @whom
    when 'all_staff_for_student'
      self.team_id = nil
    when 'predetermined_teams'
      ''
    when 'other'
      self.team_id=nil
      create_school_team(:anonymous=>true,:user_ids=>@user_ids) unless @user_ids.blank?
    end
  end
end

