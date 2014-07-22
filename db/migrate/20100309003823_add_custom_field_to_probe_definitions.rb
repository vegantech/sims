class AddCustomFieldToProbeDefinitions < ActiveRecord::Migration
  def self.up
    add_column :probe_definitions, :custom, :boolean, null: false, default: false
  end

  def self.down
    remove_column :probe_definitions, :custom
  end
end
