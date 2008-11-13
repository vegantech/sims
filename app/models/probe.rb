# == Schema Information
# Schema version: 20081111204313
#
# Table name: probes
#
#  id                               :integer         not null, primary key
#  administered_at                  :datetime
#  score                            :integer
#  assessment_type                  :string(255)
#  district_id                      :integer
#  intervention_probe_assignmnet_id :integer
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




  protected
  def before_save
    self.administered_at = Time.now  if self.administered_at.blank?
  end



  def score_in_range
    unless score.blank? || self.probe_definition.blank?||  self.probe_definition.maximum_score.blank? ||
       self.probe_definition.minimum_score.blank?
      unless  (self.probe_definition.minimum_score..self.probe_definition.maximum_score).include?(score)
      errors.add(:score, "must be between the minimum(#{self.probe_definition.minimum_score})
              and the maximum (#{self.probe_definition.maximum_score})")
      end
    end
  end
end

