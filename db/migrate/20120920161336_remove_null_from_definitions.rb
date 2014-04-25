class RemoveNullFromDefinitions < ActiveRecord::Migration
  def self.up
    GoalDefinition.update_all  ["disabled = ?", false], "disabled is null"
    ObjectiveDefinition.update_all  ["disabled = ?", false], "disabled is null"
    InterventionDefinition.update_all  ["disabled = ?", false], "disabled is null"
    InterventionCluster.update_all  ["disabled = ?", false], "disabled is null"
    change_column :goal_definitions, :disabled,:boolean, default: false, null: false
    change_column :objective_definitions, :disabled,:boolean, default: false, null: false
    change_column :intervention_clusters, :disabled,:boolean, default: false, null: false
    change_column :intervention_definitions, :disabled,:boolean, default: false, null: false
  end

  def self.down
    change_column :intervention_definitions, :disabled,:boolean, default: nil, null: true
    change_column :intervention_clusters, :disabled,:boolean, default: nil, null: true
    change_column :objective_definitions, :disabled,:boolean, default: nil, null: true
    change_column :goal_definitions, :disabled,:boolean, default: nil, null: true
  end
end
