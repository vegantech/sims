class AddTierExempttoContentHierarchy < ActiveRecord::Migration
  def self.up
    add_column :goal_definitions, :exempt_tier, :boolean, default: false, null: false
    add_column :objective_definitions, :exempt_tier, :boolean, default: false, null: false
    add_column :intervention_clusters, :exempt_tier, :boolean, default: false, null: false
    add_column :intervention_definitions, :exempt_tier, :boolean, default: false, null: false
    change_column :intervention_definitions,:disabled, :boolean, default: false, null: false
    change_column :districts,:lock_tier, :boolean, default: false, null: false
  end

  def self.down
    change_column :districts,:lock_tier, :boolean, default: false, null: true
    change_column :intervention_definitions,:disabled, :boolean, default: false, null: true
    remove_column :intervention_definitions, :exempt_tier
    remove_column :intervention_clusters, :exempt_tier
    remove_column :objective_definitions, :exempt_tier
    remove_column :goal_definitions, :exempt_tier
  end
end
