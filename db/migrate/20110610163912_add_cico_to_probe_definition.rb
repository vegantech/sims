class AddCicoToProbeDefinition < ActiveRecord::Migration
  def self.up
    add_column :probe_definitions, :cico, :boolean, :null => false, :default => false 
    add_index :probe_definitions, [:district_id, :cico]
  end

  def self.down
    remove_index :probe_definitions, :column => [:district_id, :cico]
    remove_column :probe_definitions, :cico
  end
end
