class PrincipalOverride < ActiveRecord::Base
  belongs_to :teacher, :class_name => 'User'
  belongs_to :principal, :class_name =>'User'
  belongs_to :start_tier, :class_name => 'Tier'
  belongs_to :end_tier, :class_name => 'Tier'
  belongs_to :student

  STATUS=["Awaiting approval","Approved","Rejected*","Rejected","Approved*"]

  NEW_REQUEST=0
  APPROVED_SEEN=1
  REJECTED_NOT_SEEN =2
  REJECTED_SEEN = 3

  validates_presence_of :teacher_request, :message => "reason must be provided"

  def after_initialize
    self.start_tier = student.max_tier if start_tier.blank?


  end




end
