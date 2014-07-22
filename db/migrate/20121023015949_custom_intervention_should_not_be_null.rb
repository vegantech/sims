class CustomInterventionShouldNotBeNull < ActiveRecord::Migration
  def self.up
    change_column :intervention_definitions, :custom, :boolean, null: false
  end

  def self.down
    change_column :intervention_definitions, :custom, :boolean, null: true
  end
end
