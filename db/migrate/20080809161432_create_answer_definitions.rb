class CreateAnswerDefinitions < ActiveRecord::Migration
  def self.up
    create_table :answer_definitions do |t|
      t.string :value
      t.integer :position
      t.text :text
      t.boolean :autoset_others
      t.references :district
      t.references :element_definition

      t.timestamps
    end
  end

  def self.down
    drop_table :answer_definitions
  end
end
