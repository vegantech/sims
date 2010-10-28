# == Schema Information
# Schema version: 20101027022939
#
# Table name: intervention_definitions
#
#  id                      :integer(4)      not null, primary key
#  title                   :string(255)
#  description             :text
#  custom                  :boolean(1)
#  intervention_cluster_id :integer(4)
#  tier_id                 :integer(4)
#  time_length_id          :integer(4)
#  time_length_num         :integer(4)      default(1)
#  frequency_id            :integer(4)
#  frequency_multiplier    :integer(4)      default(1)
#  user_id                 :integer(4)
#  school_id               :integer(4)
#  disabled                :boolean(1)
#  position                :integer(4)
#  created_at              :datetime
#  updated_at              :datetime
#  notify_email            :string(255)
#

class InterventionDefinition < ActiveRecord::Base

  DEFAULT_FREQUENCY_MULTIPLIER = 2
  DEFAULT_TIME_LENGTH_NUMBER = 4
  
  include ActionView::Helpers::TextHelper # to pick up pluralize
  include LinkAndAttachmentAssets
  belongs_to :intervention_cluster
  belongs_to :frequency
  belongs_to :time_length
  belongs_to :tier
  belongs_to :user
  belongs_to :school
  has_many :recommended_monitors, :order => :position, :dependent => :delete_all
  has_many :probe_definitions, :through => :recommended_monitors
  has_many :quicklist_items, :dependent => :destroy
  has_many :interventions 
  validates_presence_of :title, :description, :time_length_id, :time_length_num, :frequency_id, :frequency_multiplier
  validates_uniqueness_of :description, :scope =>[:intervention_cluster_id, :school_id, :title], :unless=>:custom
  validates_numericality_of :frequency_multiplier, :time_length_num

  acts_as_reportable if defined? Ruport
  acts_as_list :scope => :intervention_cluster_id
  define_statistic :count , :count => :all, :joins => {:intervention_cluster=>{:objective_definition=>:goal_definition}}
  define_statistic :distinct_titles , :count => :all,  :select => 'distinct intervention_definitions.title', :joins => {:intervention_cluster=>{:objective_definition=>:goal_definition}}
  define_calculated_statistic :districts_with_changes do
    find(:all,:group => "#{self.name.tableize}.title", :having => "count(#{self.name.tableize}.title)=1",:select =>'distinct district_id', :joins => {:intervention_cluster=>{:objective_definition=>:goal_definition}}).length
  end



  def title
    if custom and self[:title].present?
      "(c) #{self[:title]}"
    else
      "#{self[:title]}"
    end
  end

  def business_key
    "#{tier.position if tier}-#{goal_definition.position}-#{objective_definition.position}-#{intervention_cluster.position}-#{position}"
  end

  def district
    goal_definition.district
  end

  def district_quicklist
    !!quicklist_items.find_by_district_id(district.id)
  end

  def district_quicklist=(arg)
    @district_quicklist_arg=(arg =='1')
  end

  def goal_definition
    objective_definition.goal_definition
  end

  def objective_definition
    intervention_cluster.objective_definition
  end

  def disable!
    update_attribute(:disabled, true)
  end

  def ancestor_ids
    [objective_definition.goal_definition_id, objective_definition.id, intervention_cluster_id, id]
  end

  def bolded_title
    "<b>#{title}</b>"
  end

  def frequency_duration_summary
    "#{time_length_summary} / #{frequency_summary}"
  end

  def frequency_summary
    "#{pluralize frequency_multiplier, "time"} #{frequency.title}" if frequency
  end

  def monitor_summary
    "#{probe_definitions.collect(&:title).join("; ")}"
  end

  def time_length_summary
    pluralize time_length_num, time_length.title if time_length
  end

  def tier_summary
    tier.to_s
  end

  def links_and_attachments
    assets.collect(&:to_s).join(" ")
  end

  def recommended_monitors_with_custom
    if custom
      all_rec=RecommendedMonitor.all(:joins => :intervention_definition, :conditions => {:intervention_definitions => {:intervention_cluster_id=>self.intervention_cluster_id}})
      res=all_rec.inject([]) do |result, i|
        result << i unless !result.blank? && result.detect{|s| s.probe_definition_id == i.probe_definition_id}
        result
      end  #this should remove duplicate reccommended monitors
    else
      recommended_monitors
    end

  end
  
  def set_values_from_intervention(int)
    #Used only for custom interventions
    if new_record?
      self.school_id = int.school_id
      self.custom = true
      self.user_id = int.user_id
      self.time_length = int.time_length
      self.time_length_num = int.time_length_number
      self.frequency = int.frequency
      self.frequency_multiplier = int.frequency_multiplier
    end
  end

  
end
