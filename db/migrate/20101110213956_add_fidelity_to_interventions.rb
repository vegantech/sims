class AddFidelityToInterventions < ActiveRecord::Migration
  def self.up
    unless Intervention.column_names.include?("fidelity")
      add_column :interventions, :fidelity, :boolean
    end
  end

  def self.down
    remove_column :interventions, :fidelity
  end
end
