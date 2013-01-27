# == Schema Information
# Schema version: 20101101011500
#
# Table name: probes
#
#  id                               :integer(4)      not null, primary key
#  administered_at                  :date
#  score                            :integer(4)
#  intervention_probe_assignment_id :integer(4)
#  created_at                       :datetime
#  updated_at                       :datetime
#

class Probe < ActiveRecord::Base
  belongs_to :intervention_probe_assignment

  #delegate :something, :to=>'(something_else or return nil)' when optional
  delegate :probe_definition, :to => '(intervention_probe_assignment or return nil)'


  validates_presence_of :score
  validates_numericality_of :score
  validate :score_in_range
  scope :desc, order("administered_at DESC, id DESC")
  scope :for_graph,desc.limit(0)
  scope :for_table, desc

  before_save :set_administered_at

  define_statistic :entered_scores , :count => :all,:joins =>{:intervention_probe_assignment=>{:intervention=>:student}}
  define_statistic :students_with_entered_scores , :count => :all,  :select => 'distinct student_id', :joins => {:intervention_probe_assignment=>{:intervention=>:student}}
  define_statistic :districts_with_entered_scores, :count => :all, :select => 'distinct students.district_id', :joins => {:intervention_probe_assignment=>{:intervention=>:student}}

  protected
  def set_administered_at
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

