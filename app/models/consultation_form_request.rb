class ConsultationFormRequest < ActiveRecord::Base
  belongs_to :student
  belongs_to :requestor, :class_name => 'User'
  #  belongs_to :team

  after_create :email_requests

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
    end

  end
end

