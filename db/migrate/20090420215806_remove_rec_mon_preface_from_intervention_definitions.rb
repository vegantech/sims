class RemoveRecMonPrefaceFromInterventionDefinitions < ActiveRecord::Migration
  def self.up
    remove_column :intervention_definitions, :rec_mon_preface
  end

  def self.down
    add_column :intervention_definitions, :rec_mon_preface, :string
  end
end
