# == Schema Information
# Schema version: 20090428193630
#
# Table name: intervention_definitions
#
#  id                      :integer         not null, primary key
#  title                   :string(255)
#  description             :text
#  custom                  :boolean
#  intervention_cluster_id :integer
#  tier_id                 :integer
#  time_length_id          :integer
#  time_length_num         :integer         default(1)
#  frequency_id            :integer
#  frequency_multiplier    :integer         default(1)
#  user_id                 :integer
#  school_id               :integer
#  disabled                :boolean
#  position                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  deleted_at              :datetime
#  copied_at               :datetime
#  copied_from             :integer
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
  has_many :recommended_monitors, :order => :position, :dependent => :destroy
  has_many :probe_definitions, :through => :recommended_monitors
  has_many :quicklist_items, :dependent => :destroy
  has_many :interventions do

    def build_with_default(opts={})
      i=self.build(opts.reverse_merge(:frequency => proxy_owner.frequency, 
                                              :frequency_multiplier => proxy_owner.frequency_multiplier, 
                                              :time_length_number => proxy_owner.time_length_num, 
                                              :time_length => proxy_owner.time_length)
                         )
      if proxy_owner.new_record?
        proxy_owner.frequency = i.frequency
        proxy_owner.frequency_multiplier = i.frequency_multiplier
        proxy_owner.time_length_num = i.time_length_number
        proxy_owner.time_length = i.time_length
        proxy_owner.school_id = i.school_id
        proxy_owner.custom = true
        proxy_owner.user_id = i.user_id
      end
      i
        
    end
  end

  validates_presence_of :title, :description, :time_length_id, :time_length_num, :frequency_id, :frequency_multiplier
  validates_uniqueness_of :description, :scope =>[:intervention_cluster_id, :school_id, :title, :deleted_at]
  validates_numericality_of :frequency_multiplier, :time_length_num

  acts_as_reportable if defined? Ruport
  acts_as_list :scope => 'intervention_cluster_id'
  after_save :update_district_quicklist
  is_paranoid
  

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



  
  protected
  def update_district_quicklist
    return true if intervention_cluster.blank?   #TODO fix delegation
    if @district_quicklist_arg
      quicklist_items.create(:district_id=>self.district.id) unless district_quicklist
    elsif !new_record?
      g=quicklist_items.find_by_district_id(self.district.id) 
      g.destroy if g 
    end
  end

  private
  def deep_clone_parent_field
    'intervention_cluster_id'
  end

  def deep_clone_children
    %w{intervention_definitions}
  end



end
