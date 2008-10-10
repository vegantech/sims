class CreateElementDefinitions < ActiveRecord::Migration
  def self.up
    create_table :element_definitions do |t|
      t.belongs_to :question_definition
      t.text :text
      t.string :kind
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :element_definitions
  end
end
