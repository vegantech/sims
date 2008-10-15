class CreateObjectiveDefinitions < ActiveRecord::Migration
  def self.up
    create_table :objective_definitions do |t|
      t.string :title
      t.text :description
      t.belongs_to :goal_definition
      t.integer :position
      t.boolean :disabled

      t.timestamps
    end
  end

  def self.down
    drop_table :objective_definitions
  end
end
