class CreateElementDefinitions < ActiveRecord::Migration
  def self.up
    create_table :element_definitions do |t|
      t.question_definition :references
      t.integer :position
      t.string :kind
      t.text :text
      t.district :references

      t.timestamps
    end
  end

  def self.down
    drop_table :element_definitions
  end
end
