class ProbeDefinition < ActiveRecord::Base
  belongs_to :district
  has_many :probe_definition_benchmarks, :order =>:grade_level, :dependent=>:destroy
  validates_presence_of :title, :description
  validates_uniqueness_of :title, :scope => ['active','district_id']
  validates_numericality_of :maximum_score, :allow_nil=> true
  validates_numericality_of :minimum_score, :allow_nil=> true
  validates_associated(:probe_definition_benchmarks)

  acts_as_list :scope=>:district_id
  
  def validate
    #TODO this can be refactored out using rails 2.x changes
    if minimum_score!= nil && maximum_score!=nil && minimum_score > maximum_score
      errors.add(:minimum_score, "must be less than the maximum score.")
    end
  end

  def probes
    probe_definition_benchmarks
  end


  def self.group_by_cluster_and_objective
    #This will work better
    probes=find(:all,:order =>:position)
    my_hash = ActiveSupport::OrderedHash.new()
    my_hash[:unassigned_probe_definitions]={:clusters=>{}}
    my_hash[:unassigned_probe_definitions][:clusters][:none] = {}
    my_hash[:unassigned_probe_definitions][:clusters][:none]={:probes=>[]}

    probes.each do |probe|
      my_hash[:unassigned_probe_definitions][:clusters][:none][:probes] << probe
    end

    
    my_hash
  end


end

