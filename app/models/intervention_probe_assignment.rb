# == Schema Information
# Schema version: 20090623023153
#
# Table name: intervention_probe_assignments
#
#  id                   :integer(4)      not null, primary key
#  intervention_id      :integer(4)
#  probe_definition_id  :integer(4)
#  frequency_multiplier :integer(4)
#  frequency_id         :integer(4)
#  first_date           :date
#  end_date             :date
#  enabled              :boolean(1)
#  created_at           :datetime
#  updated_at           :datetime
#

class InterventionProbeAssignment < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  belongs_to :intervention
  belongs_to :probe_definition
  belongs_to :frequency
  has_many :probes, :dependent => :destroy
  

  delegate :title, :to => :probe_definition
  delegate :student, :to => :intervention
  validates_associated :probes #,:probe_definition
  validate :last_date_must_be_after_first_date
  validate :goal_in_range

  accepts_nested_attributes_for :probe_definition

  RECOMMENDED_FREQUENCY = 2

#  validates_date :first_date, :end_date

  named_scope :active, :conditions => {:enabled=>true}


  def self.disable(ipas)
    Array(ipas).each(&:disable)
  end

  def disable
    update_attributes(:enabled=>false)
  end

  def student_grade
    #TODO delegate this
    student.enrollments.first.grade
  end

  def frequency_summary
    "#{pluralize frequency_multiplier, "time"} #{frequency}"
  end

  def valid_score_range
    "#{probe_definition.minimum_score} - #{probe_definition.maximum_score}"
  end

  def new_probes=(params)
    params=params.values
    params.each do |param|
      @new_probe = probes.build(param) unless param['score'].blank?
    end
  end

  def to_param
    unless new_record?
      id
    else
      "pd#{probe_definition_id}"
    end
  end

  def google_line_or_bar_chart graph_type=nil
    if probes_for_graph.size <2 or graph_type=="bar"
      google_bar_chart
    else
      google_line_chart or "graph_type"=="line"
    end

  end

 def google_line_chart
   #groups of 10, repeats the previous point on the next graph as a line graph needs at least 2 points
   return ''if probes_for_graph.empty?
    custom_chm=[numbers_on_line,max_min_zero].join("|")
    custom_string = [custom_chm,chart_margins,benchmark_lines].compact.join("&")
    group=0
    probes_for_graph.in_groups_of(10,false).collect{|probes_for_this_graph|
      if group>0
        probes_for_this_graph= [probes_for_graph[group*10-1]] + probes_for_this_graph
      end
      group+=1
    
    
      Gchart.line(:data => probes_for_this_graph.collect(&:score), :axis_with_labels => 'x,x,y,r',
                 :axis_labels => [probes_for_this_graph.collect{|p| p.administered_at.to_s(:report)}, probes_for_this_graph.collect(&:score), [min,0,max],benchmarks.collect{|b| "#{b.benchmark}- Gr. #{b.grade_level}"}], 
                 :bar_width_and_spacing => '30,25',
                 :bar_colors => probes_for_this_graph.collect{|e| (e.score<0)? '8DACD0': '5A799D'}.join("|"),
                 :format=>'image_tag',
                 :min_value=>min, :max_value=>max,
                 :encoding => 'text',
                 :custom => custom_string,
                 :size => '600x250'

                 )}.join("<br />")



 end
 def google_bar_chart
   #groups of 10
   return ''if probes_for_graph.empty?
    custom_chm=[numbers_in_bars,max_min_zero].join("|")
    custom_string = [custom_chm,chart_margins,benchmark_lines].compact.join("&")
    probes_for_graph.in_groups_of(10,false).collect{|probes_for_this_graph|
      Gchart.bar(:data => probes_for_this_graph.collect(&:score), :axis_with_labels => 'x,x,y,r',
                 :axis_labels => [probes_for_graph.collect{|p| p.administered_at.to_s(:report)}, probes_for_this_graph.collect(&:score), [min,0,max],benchmarks.collect{|b| "#{b.benchmark}- Gr. #{b.grade_level}"}], 
                 :bar_width_and_spacing => '30,25',
                 :bar_colors => probes_for_this_graph.collect{|e| (e.score<0)? '8DACD0': '5A799D'}.join("|"),
                 :format=>'image_tag',
                 :min_value=>min, :max_value=>max,
                 :encoding => 'text',
                 :custom => custom_string,
                 :size => '600x250'

                )}.join("<br />")
  end

  def probes_for_graph
    probes.reject{|e| e.administered_at.blank? || e.score.blank?}.sort_by(&:administered_at)
  end

  def benchmarks
    probe_definition.probe_definition_benchmarks
  end

  protected
  def numbers_on_line
    #show the value in black on the graph
      'chm=N,000000,0,,12,,t'
  end
  def numbers_in_bars
    #show the value in white in the bar
      'chm=N,FFFFFF,0,,12,,c'
  end

  def max_min_zero
    #min, zero, max
    "chm=r,000000,0,0.0,0.002|r,000000,0,#{scale_value(0) - 0.001},#{scale_value(0) + 0.001}|r,000000,0,0.998,1.0&chxp=2,#{scale_value(min)*100},#{scale_value(0)*100},#{scale_value(max)*100}"
  end

  def benchmark_lines
    if benchmarks.present?
      "chm=#{benchmarks.collect{|b| "r,ff9c00,0,#{scale_value(b.benchmark)-0.001},#{scale_value(b.benchmark) + 0.001}"}.join("|")}" + "&chxp=3,#{benchmarks.collect{|b| scale_value(b.benchmark)*100}.join(",")}"
    end
  end

  def chart_margins
    "chma=20,20,20,20"
    ""
  end

  
  def scale_value(value)
    (value-min).to_f/(max-min).to_f
  end

  def min
    probe_definition.minimum_score || (probes_for_graph.collect(&:score).min >=0 ? 0 : probes_for_graph.collect(&:score).min)
  end

  def max
    probe_definition.maximum_score || (probes_for_graph.collect(&:score).max <= 10 ? 10 : probes_for_graph.collect(&:score).max)
  end
   




  def last_date_must_be_after_first_date
    errors.add(:end_date, "Last date must be after first date")     if self.first_date.blank? || self.end_date.blank? || self.end_date < self.first_date
  end

  def after_initialize
    self.frequency_multiplier=RECOMMENDED_FREQUENCY if self.frequency_multiplier.blank?
  end

  def goal_in_range
    if goal.present? and self.probe_definition.present?
      if probe_definition.minimum_score.present? and goal < probe_definition.minimum_score
        errors.add(:goal, "below minimum") and return false
      end

      if probe_definition.maximum_score.present? and goal > probe_definition.maximum_score
        errors.add(:goal, "above maximum") and return false
      end

    end
        
  end

end
