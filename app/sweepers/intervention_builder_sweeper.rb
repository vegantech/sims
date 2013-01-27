class InterventionBuilderSweeper < ActionController::Caching::Sweeper
  observe GoalDefinition,ObjectiveDefinition,InterventionCluster,InterventionDefinition,RecommendedMonitor,ProbeDefinition

  def after_create(obj)
    expire_cache_for(obj)
  end

  def after_update(obj)
    expire_cache_for(obj)
  end

  def after_destroy(obj)
    expire_cache_for(obj)
  end

  private
  def expire_cache_for(obj)
    if obj.respond_to?(:objective_definitions)
      return nil if obj.district.blank?
      obj.objective_definitions.each{|o| expire_cache_for_objective_definition(o)}
      obj.district.touch
    elsif obj.respond_to?(:objective_definition)
      return nil if obj.try(:objective_definition).try(:district).blank?
      expire_cache_for_objective_definition(obj.objective_definition)
      obj.objective_definition.district.touch
    elsif obj.is_a?(ObjectiveDefinition)
      return nil if obj.district.blank?
      expire_cache_for_objective_definition(obj)
      obj.district.touch
    end
  end

  def expire_cache_for_objective_definition(objective_definition)
    district = objective_definition.district
    FileUtils.rm(Dir.glob(Rails.root.join("public","system","district_generated_docs",district.id.to_s,"#{objective_definition.filename}.*")))
  end

end
