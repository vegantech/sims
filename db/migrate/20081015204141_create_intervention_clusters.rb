class CreateInterventionClusters < ActiveRecord::Migration
  def self.up
    create_table :intervention_clusters do |t|
      t.string :title
      t.text :description
      t.belongs_to :objective_definition
      t.integer :position
      t.boolean :disabled

      t.timestamps
    end
  end

  def self.down
    drop_table :intervention_clusters
  end
end
