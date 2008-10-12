class CreateAnswerDefinitions < ActiveRecord::Migration
  def self.up
    create_table :answer_definitions do |t|
      t.belongs_to :element_definition
      t.text :text
      t.string :value
      t.integer :position
      t.boolean :autoset_others

      t.timestamps
    end
  end

  def self.down
    drop_table :answer_definitions
  end
end
