class Recommendation < ActiveRecord::Base
 validates_presence_of :progress, :message => "is not indicated"
  validates_presence_of :recommendation, :message => "is not indicated"
  validates_presence_of :reason, :if=>lambda{|r| [4,5].include?(r.recommendation.to_i)}
  belongs_to :checklist
  validates_presence_of :checklist_id
  attr_accessor :request_referral

  def set_reason_from_previous!
    st_list=Checklist::STATUS
    st=checklist.previous_checklist.status unless checklist.previous_checklist.blank?

    if st && [st_list[:cannot_refer],
      st_list[:ineligable_to_refer],
      st_list[:failing_score]].include?(st)
      self.reason ||= checklist.previous_checklist.recommendation.reason
    end
    self.reason
  end


  protected

  def validate
    unless errors.on :recommendation
      errors.add(:other, "must be filled out when selected") if recommendation == 6
    end
  end

  def request_referral
    @request_referral ||= (should_advance && recommendation == 5)
  end

  def before_save
    if errors.empty? and [4,5].include? recommendation.to_i
      self.should_advance=true
      self.should_advance = request_referral if recommendation.to_i==5
    end
  end

  def after_save
    if self.should_advance?
      validate_for_tier_escalation
    end
  end

  def validate_for_tier_escalation
    checklist.score_checklist
    checklist.promoted=checklist.score_results.blank?
    checklist.save
  end

end
