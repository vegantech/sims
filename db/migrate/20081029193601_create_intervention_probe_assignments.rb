class CreateInterventionProbeAssignments < ActiveRecord::Migration
  def self.up
    create_table :intervention_probe_assignments do |t|
      t.belongs_to :intervention
      t.belongs_to :probe_definition
      t.integer :frequency_multiplier
      t.belongs_to :frequency
      t.datetime :first_date
      t.datetime :end_date
      t.boolean :enabled, :default=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :intervention_probe_assignments
  end
end
