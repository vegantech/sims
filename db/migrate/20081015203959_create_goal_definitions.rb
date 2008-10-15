class CreateGoalDefinitions < ActiveRecord::Migration
  def self.up
    create_table :goal_definitions do |t|
      t.string :title
      t.text :description
      t.belongs_to :district
      t.integer :position
      t.boolean :disabled

      t.timestamps
    end
  end

  def self.down
    drop_table :goal_definitions
  end
end
