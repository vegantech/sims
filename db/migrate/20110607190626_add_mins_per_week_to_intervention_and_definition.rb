class AddMinsPerWeekToInterventionAndDefinition < ActiveRecord::Migration
  def self.up
    add_column :intervention_definitions, :mins_per_week, :integer, :default => 0, :null => false
    add_column :interventions, :mins_per_week, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :interventions, :mins_per_week
    remove_column :intervention_definitions, :mins_per_week
  end
end
