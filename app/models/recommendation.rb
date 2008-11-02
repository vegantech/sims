# == Schema Information
# Schema version: 20081030035908
#
# Table name: recommendations
#
#  id                           :integer         not null, primary key
#  progress                     :integer
#  recommendation               :integer
#  checklist_id                 :integer
#  user_id                      :integer
#  reason                       :text
#  should_advance               :boolean
#  created_at                   :datetime
#  updated_at                   :datetime
#  recommendation_definition_id :integer
#

class Recommendation < ActiveRecord::Base
  belongs_to :checklist
  belongs_to :recommendation_definition
  belongs_to :user
  belongs_to :student
  belongs_to :tier
  belongs_to :district
  has_many :recommendation_answers


  validates_presence_of :recommendation, :message => "is not indicated"
  validates_presence_of :reason, :if=>lambda{|r| r.recommendation && RECOMMENDATION[r.recommendation][:promote]}
#  validates_presence_of :checklist_id, 
  validates_presence_of :other, :if => lambda{|r| r.recommendation && RECOMMENDATION[r.recommendation][:require_other]}
  attr_accessor :request_referral
  attr_accessor :other

  RECOMMENDATION={
    0=>{:text=>"The student made progress and no longer requires intervention."},
    1 =>{:text=>"The student is making progress; choose new interventions from the next level to accelerate progress or address additional needs; continue to monitor progress.",:promote=>true},
    3=>{:text => "The student has not made progress.  Choose new interventions from the current level and continue to monitor progress."},
    4 => {:text => "The student has not made progress.  Choose new interventions from the next level and continue to monitor progress.",:promote=>true},
    5 => {:text => "The student has not made progress and multiple attempts at intervention have been tried.  Make a referral to special education.",:promote=>true,
          :show_elig => true},
    6 => {:text => "Other", :require_other => true ,:promote=>true}
  
  }

  

  def answers
    recommendation_definition.recommendation_answer_definitions.each do |ad|
      self.recommendation_answers.build(:recommendation_answer_definition=>ad) unless recommendation_answers.any?{|a| a.recommendation_answer_definition == ad}
    end
    self.recommendation_answers
  end

  def answers=(hsh={})
    hsh.each do |h|
      a=self.recommendation_answers.detect{|r| r.recommendation_answer_definition_id == h[:recommendation_answer_definition_id] } ||
        recommendation_answers.build(h)
      a.text=h[:text]
    end
  end



  def set_reason_from_previous!
    st_list=Checklist::STATUS
    st=checklist.previous_checklist.status unless checklist.blank? or checklist.previous_checklist.blank?

    if st && [st_list[:cannot_refer],
      st_list[:ineligable_to_refer],
      st_list[:failing_score]].include?(st)
      self.reason ||= checklist.previous_checklist.recommendation.reason
    end
    self.reason
  end


  protected

  def after_initialize
    if checklist
      self.recommendation_definition ||= checklist.checklist_definition.recommendation_definition if checklist
      self.district_id ||= checklist.district_id 
      self.student_id ||= checklist.student_id
      self.tier_id ||= checklist.from_tier
    else
      self.recommendation_definition=RecommendationDefinition.find_by_active(true)
    end
  end

  def request_referral
    @request_referral ||= (should_advance && recommendation == 5)
  end

  def before_save
    if errors.empty? and RECOMMENDATION[recommendation][:promote]
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
