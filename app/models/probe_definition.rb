# == Schema Information
# Schema version: 20090325230037
#
# Table name: probe_definitions
#
#  id            :integer         not null, primary key
#  title         :string(255)
#  description   :text
#  user_id       :integer
#  district_id   :integer
#  active        :boolean         default(TRUE)
#  maximum_score :integer
#  minimum_score :integer
#  school_id     :integer
#  position      :integer
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#  copied_at     :datetime
#  copied_from   :integer
#

# Also referred to as "Progress Monitors"
class ProbeDefinition < ActiveRecord::Base
  include LinkAndAttachmentAssets
  belongs_to :district
  has_many :probe_definition_benchmarks, :order =>:grade_level, :dependent => :destroy, :before_add => proc {|pd,pdb| pdb.probe_definition=pd}
  has_many :recommended_monitors, :dependent => :destroy
  has_many :intervention_definitions,:through => :recommended_monitors
  has_many :intervention_probe_assignments
  has_many :probe_questions
  accepts_nested_attributes_for :probe_definition_benchmarks, :allow_destroy => true, :reject_if=>proc {|attrs| attrs.values.all?(&:blank?)}

  validates_presence_of :title, :description
  validates_uniqueness_of :title, :scope => ['active', 'district_id', :deleted_at]
  validates_numericality_of :maximum_score, :allow_nil => true
  validates_numericality_of :minimum_score, :allow_nil => true
  #validates_associated(:probe_definition_benchmarks)

  acts_as_list :scope => :district_id
  is_paranoid
  
  def validate
    #TODO this can be refactored out using rails 2.x changes
    if minimum_score != nil && maximum_score != nil && minimum_score > maximum_score
      errors.add(:minimum_score, "must be less than the maximum score.")
    end
  end

  def probes
    intervention_probe_assignments
  end

  def deep_clone(district)
    k=district.probe_definitions.find_with_destroyed(:first,:conditions=>{:copied_from=>id, :district_id => district.id}) 
    if k
      #it already exists
   else
      k=clone
      k.district=district
      k.copied_at=Time.now
      k.copied_from = id
      k.save! if k.valid?
    end
     
    k.probe_definition_benchmarks << probe_definition_benchmarks.collect{|o| o.deep_clone(k)}
    k.probe_questions << probe_questions.collect{|o| o.deep_clone(k)}
    k
  end

  def self.group_by_cluster_and_objective
    #This will work better
    probes = find(:all, :order =>:position)

    my_hash = ActiveSupport::OrderedHash.new()

    unassigned = {:clusters => {}}
    unassigned[:clusters][:none] = {:probes=>[]}

    probes.each do |probe|
      if probe.intervention_definitions.any?
        probe.intervention_definitions.each do |id|
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
    my_hash[:unassigned_probe_definitions] = unassigned

    my_hash
  end
end
