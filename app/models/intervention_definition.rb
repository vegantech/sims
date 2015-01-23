# == Schema Information
# Schema version: 20101101011500
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
  DISTRICT_PARENT = :intervention_cluster

  DEFAULT_FREQUENCY_MULTIPLIER = 2
  DEFAULT_TIME_LENGTH_NUMBER = 4
  TIME_LENGTH_NUM = :time_length_num
  include ActionView::Helpers::TextHelper # to pick up pluralize
  include LinkAndAttachmentAssets
  include FrequencyAndDuration

  belongs_to :intervention_cluster
  belongs_to :tier
  belongs_to :user
  belongs_to :school
  has_many :recommended_monitors, :order => :position, :dependent => :delete_all
  has_many :probe_definitions, :through => :recommended_monitors
  has_many :quicklist_items, :dependent => :destroy
  has_many :interventions
  validates_presence_of :title, :description
  validates_uniqueness_of :description, :scope =>[:intervention_cluster_id, :school_id, :title], :unless=>:custom

  acts_as_list :scope => :intervention_cluster_id
  define_statistic :count , :count => :all, :joins => {:intervention_cluster=>{:objective_definition=>:goal_definition}}
  define_statistic :distinct_titles , :count => :all,  :column_name => 'distinct intervention_definitions.title', :joins => {:intervention_cluster=>{:objective_definition=>:goal_definition}}
  define_calculated_statistic :districts_with_changes do
    find(:all,:group => "#{self.name.tableize}.title", :having => "count(#{self.name.tableize}.title)=1",:select =>'distinct district_id', :joins => {:intervention_cluster=>{:objective_definition=>:goal_definition}}).length
  end

  scope :restrict_tiers_and_disabled, lambda {|student_tier, district|
    if district.lock_tier?
      enabled.restrict_tiers(student_tier)
    else
      enabled
    end
  }
  scope :restrict_tiers, lambda{ |student_tier|
    where("goal_definitions.exempt_tier or objective_definitions.exempt_tier or intervention_clusters.exempt_tier or intervention_definitions.exempt_tier or
          tiers.position <= #{student_tier.position}").joins([:tier, {:intervention_cluster => {:objective_definition => :goal_definition }}])
  }


  scope :general, where(["intervention_definitions.custom is null or intervention_definitions.custom = ?",false])
  scope :content_export, general
  scope :enabled, where(:disabled => false)
  scope :for_report, general.enabled.includes(
  [:tier,:frequency,:time_length,:probe_definitions,:assets,{:intervention_cluster => {:objective_definition => :goal_definition}}]
  ).order("tiers.position,intervention_clusters.position,intervention_definitions.position")

  scope :for_dropdown, lambda {|student_tier, district, school_id, user|
    res=restrict_tiers_and_disabled(student_tier, district)
      if ["disabled","only_author"].include? district.custom_interventions
        #shared only with author
        return res.where(["custom = ? or user_id = ?", false, user.id])
        elsif district.custom_interventions == 'one_off'
          return res.where(["custom = ?", false])
        else
        #shared with author and school (enabled and content_admins)
        return res.where(["custom = ? or user_id = ? or school_id = ?", false, user.id,school_id])
      end
  }

  delegate :goal_definition_id, :objective_definition_id, :to => :intervention_cluster

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

  def monitor_summary
    "#{probe_definitions.collect(&:title).join("; ")}"
  end

  def tier_summary
    tier.to_s
  end

  def active_progress_monitors
    if custom
      active_progress_monitors_with_custom
    else
      active_progress_monitors_without_custom
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

private
  def active_progress_monitors_without_custom
    active_progress_monitors_base.merge recommended_monitors.scoped
  end

  def active_progress_monitors_with_custom
    active_progress_monitors_base.joins(:intervention_definitions).where(
      "intervention_definitions.intervention_cluster_id" => self.intervention_cluster_id)
      .where("recommended_monitors.intervention_definition_id = intervention_definitions.id").uniq
  end

  def active_progress_monitors_base
    ProbeDefinition.active.joins(:recommended_monitors).order("recommended_monitors.position")
  end

  def self.filter(opts ={})
    disabled = !!opts[:disabled]
    enabled = opts[:enabled]
    custom = !!opts[:custom]
    system = !!opts[:system]
    where(["custom = ? or custom = ?",custom,!system]).
      where(["disabled = ? or disabled = ?", disabled, (!enabled & disabled)])
  end
end
