# == Schema Information
# Schema version: 20101027022939
#
# Table name: probe_definitions
#
#  id            :integer(4)      not null, primary key
#  title         :string(255)
#  description   :text
#  user_id       :integer(4)
#  district_id   :integer(4)
#  active        :boolean(1)      default(TRUE)
#  maximum_score :integer(4)
#  minimum_score :integer(4)
#  school_id     :integer(4)
#  position      :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  custom        :boolean(1)      not null
#

# Also referred to as "Progress Monitors"
class ProbeDefinition < ActiveRecord::Base
  include LinkAndAttachmentAssets
  belongs_to :district
  belongs_to :user
  belongs_to :school
  has_many :probe_definition_benchmarks, :order =>:grade_level, :dependent => :destroy, :before_add => proc {|pd,pdb| pdb.probe_definition=pd}
  has_many :recommended_monitors, :dependent => :delete_all
  has_many :intervention_definitions,:through => :recommended_monitors
  has_many :intervention_probe_assignments
  has_many :probe_questions, :dependent => :delete_all
  accepts_nested_attributes_for :probe_definition_benchmarks, :allow_destroy => true, :reject_if=>proc {|attrs| attrs.values.all?(&:blank?)}

  validates_presence_of :title, :description
  validates_uniqueness_of :title, :scope => ['active', 'district_id']
  validates_numericality_of :maximum_score, :allow_nil => true
  validates_numericality_of :minimum_score, :allow_nil => true
  #validates_associated(:probe_definition_benchmarks)

  acts_as_list :scope => :district_id

  define_statistic :count , :count => :all
  define_statistic :distinct , :count => :all,  :select => 'distinct title'
  define_calculated_statistic :districts_with_changes do
    find(:all,:group => "#{self.name.tableize}.title", :having => "count(#{self.name.tableize}.title)=1",:select =>'distinct district_id').length
  end

  acts_as_reportable if defined? Ruport
  
  def validate
    #TODO this can be refactored out using rails 2.x changes
    if minimum_score != nil && maximum_score != nil && minimum_score > maximum_score
      errors.add(:minimum_score, "must be less than the maximum score.")
    end
  end

  def title
    if custom and self[:title].present?
      "(c) #{self[:title]}"
    else
      "#{self[:title]}"
    end
  end



  def probes
    intervention_probe_assignments
  end

  def self.group_by_cluster_and_objective(params ={})
    #This will work better

    #refactor this to use recommended monitors?
    probes = find(:all, :order =>"active desc, custom, position", :include => [{:intervention_definitions=>{:intervention_cluster=>:objective_definition}},:intervention_probe_assignments, :recommended_monitors])


    if params[:commit]
      if params[:enabled] || params[:disabled]
        probes.reject!(&:active) unless params[:enabled]
        probes = probes.select(&:active) unless params[:disabled]
      end
      
      if params[:custom] || params[:system]
        probes.reject!(&:custom) unless params[:custom]
        probes = probes.select(&:custom) unless params[:system]
      end
    end




    my_hash = ActiveSupport::OrderedHash.new()

    unassigned = {:clusters => {}}
    unassigned[:clusters][:none] = {:probes=>[]}

    probes.each do |probe|
      if probe.intervention_definitions.any?
        probe.intervention_definitions.compact.each do |id|
          ic=id.intervention_cluster
          od=ic.objective_definition
          my_hash[od.title] ||= {:clusters=>{}}
          my_hash[od.title][:clusters][ic.title] ||= {:probes=>[]}
          my_hash[od.title][:clusters][ic.title][:probes] |= [probe]
        end
      else
        unassigned[:clusters][:none][:probes] << probe
      end
    end
    unassigned[:clusters][:none][:probes]=  unassigned[:clusters][:none][:probes].sort_by{|e| e.title}
    my_hash[:unassigned_progress_monitors] = unassigned

    my_hash
  end

  def cache_key
    super + "-probes-#{probes.empty?}"
  end


end
