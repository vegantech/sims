class ChangeDateTimestoDates < ActiveRecord::Migration
  def self.up
    change_column :intervention_probe_assignments, :first_date, :date
    change_column :intervention_probe_assignments, :end_date, :date
    change_column :probes, :administered_at, :date
  end

  def self.down
    change_column :probes, :administered_at, :datetime
    change_column :intervention_probe_assignments, :end_date, :datetime
    change_column :intervention_probe_assignments, :first_date, :datetime
  end
end
