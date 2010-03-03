# == Schema Information
# Schema version: 20090623023153
#
# Table name: principal_overrides
#
#  id                 :integer(4)      not null, primary key
#  teacher_id         :integer(4)
#  student_id         :integer(4)
#  principal_id       :integer(4)
#  status             :integer(4)      default(0)
#  start_tier_id      :integer(4)
#  end_tier_id        :integer(4)
#  principal_response :string(1024)
#  teacher_request    :string(1024)
#  created_at         :datetime
#  updated_at         :datetime
#

class PrincipalOverride < ActiveRecord::Base
  belongs_to :teacher, :class_name => 'User'
  belongs_to :principal, :class_name =>'User'
  belongs_to :start_tier, :class_name => 'Tier'
  belongs_to :end_tier, :class_name => 'Tier'
  belongs_to :student
  attr_accessor :action, :skip_email
  attr_reader :unavailable_reason, :send_email

  STATUS=["Awaiting approval","Approved","Rejected*","Rejected","Approved*"]

  NEW_REQUEST=0
  APPROVED_SEEN=1
  REJECTED_NOT_SEEN =2
  REJECTED_SEEN = 3
  APPROVED_NOT_SEEN =4


  validates_inclusion_of :action, :in =>['accept','reject'], :unless => Proc.new{|p| p.status == NEW_REQUEST} 
  validates_presence_of :teacher_request, :message => "reason must be provided"
  validates_presence_of :principal_response, :message => "Reason must be provided", :unless => Proc.new{|p| p.status == NEW_REQUEST}
  named_scope :pending, :conditions=>{:status=>NEW_REQUEST}
  named_scope :approved, :conditions=>{:status=>[APPROVED_SEEN,APPROVED_NOT_SEEN]}


  def self.pending_for_principal(user)
    pnd=pending.find(:all,:joins=>:student,   :conditions => {:students => {:district_id => user.district_id }})
    pnd.select do |p|
      !p.student.blank? && p.student.principals.include?(user) 
    end
  end

  def self.max_tier
    approved.collect(&:end_tier).compact.max
  end
  
  def setup_response_for_edit(action)
    #TODO Autoset to next or max tier

    @action=action
    self.end_tier=self.start_tier

  end

  def status_text
    STATUS[self.status]
  end

  def undo!
    self.principal=nil
    self.principal_response=nil
    self.end_tier=nil
    self.status=NEW_REQUEST
    @action="undo"
    self.save!

  end


  def can_create?
    @unavailable_reason = ''
    if self.start_tier.blank?
      @unavailable_reason += "Overrides unavailable, no tiers defined."
    end

    if student.principals.blank?
      @unavailable_reason += "There are no principals assigned to this student"
    end

    
    @unavailable_reason.blank?
  end

  protected

  def after_initialize
    self.start_tier = student.max_tier if start_tier.blank? and !student.blank?
  end



  def before_validation_on_update
    #TODO make sure the principal is actually a principal for this student
    #Refactor this
    @send_email=true unless @skip_email
    case self.action
    when 'accept':
      self.status=APPROVED_NOT_SEEN
      check_autopromote
    when 'reject':
      self.status=REJECTED_NOT_SEEN
    when 'undo'
      @send_email=false
    else
      @send_email=false
      self.status=-1
    end
    true

  end

  def check_autopromote
    if student and student.district 
      auto_texts = student.district.principal_override_reasons.find_all_by_autopromote(true).collect(&:reason)
      if auto_texts.present? and auto_texts.include? principal_response
        self.end_tier = student.district.tiers.last
      end
    end

  end


end
