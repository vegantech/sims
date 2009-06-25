# == Schema Information
# Schema version: 20090623023153
#
# Table name: probes
#
#  id                               :integer(4)      not null, primary key
#  administered_at                  :date
#  score                            :integer(4)
#  district_id                      :integer(4)
#  intervention_probe_assignment_id :integer(4)
#  created_at                       :datetime
#  updated_at                       :datetime
#

class Probe < ActiveRecord::Base
  belongs_to :intervention_probe_assignment

  has_and_belongs_to_many :probe_questions  #incorrect answers

  #delegate :something, :to=>'(something_else or return nil)' when optional
  delegate :probe_definition, :to => '(intervention_probe_assignment or return nil)'


  validates_presence_of :score
  validates_numericality_of :score
  validate :score_in_range
  named_scope :for_graph,:order=>"administered_at DESC, id DESC", :limit=>8
  attr_accessor :assessment_type



def calculate_score(params)
  self.score=0

  if assessment_type == 'baseline'
    questions = probe_definition.probe_questions

  elsif assessment_type == 'update'
    # This is may return the current probe, I'm not yet sure what the purpose is,  I just combined a few lines to produce the identical result
    previous_probe = intervention_probe_assignment.probes.last
    questions=previous_probe.probe_questions
    self.score=previous_probe.score
  else
    raise "unknown assessment type"
  end

  questions.each do |question|
    if (params["first_number_#{question.number}"].to_s.empty? && params["second_number_#{question.number}"].to_s.empty? && (params["counts_everything_#{question.number}"]!='Counts everything' && params["shows_both_#{question.number}"]!='Shows both sets' && params["more_respond_#{question.number}"]!='More than 3-4 seconds to respond' && params["no_response_#{question.number}"]!='No response') && params["answer_#{question.number}"].to_i == question.first_digit+question.second_digit)
      self.score = self.score + 1
    else
      probe_questions << question
      # self.probe_updates.create(:probe_question_definition_id => question.probe_question_definition_id, :probe_id => self.probe_id )
    end
  end
  end


  QUESTIONS_PER_GROUP=10
  def grouped_questions
    @grouped_questions ||=
    if assessment_type.to_s == "baseline"
      probe_definition.probe_questions.in_groups_of(QUESTIONS_PER_GROUP,false)
    elsif assessment_type.to_s == "update"
      previous_probe = intervention_probe_assignment.probes.last
      previous_probe.probe_questions.in_groups_of(QUESTIONS_PER_GROUP,false)
    else
      raise "UNKNOWN assessment type #{assessment_type} #{@grouped_questions.inspect}"
    end

  end




  protected
  def before_save
    self.administered_at = Time.now  if self.administered_at.blank?
  end



  def score_in_range
    if score.present? and self.probe_definition.present?
      if probe_definition.minimum_score.present? and score < probe_definition.minimum_score
        errors.add(:score, "below minimum") and return false
      end

      if probe_definition.maximum_score.present? and score > probe_definition.maximum_score
        errors.add(:score, "above maximum") and return false
      end

    end
        
  end
end

