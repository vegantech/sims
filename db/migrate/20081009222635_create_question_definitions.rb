class CreateQuestionDefinitions < ActiveRecord::Migration
  def self.up
    create_table :question_definitions do |t|
      t.belongs_to :checklist_definition
      t.text :text
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :question_definitions
  end
end
