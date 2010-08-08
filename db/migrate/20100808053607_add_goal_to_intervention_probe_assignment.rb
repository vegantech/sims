class AddGoalToInterventionProbeAssignment < ActiveRecord::Migration
  def self.up
    add_column :intervention_probe_assignments, :goal, :integer
  end

  def self.down
    remove_column :intervention_probe_assignments, :goal
  end
end
