class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.text :text
      t.references :district
      t.references :answer_definition_definition
      t.references :checklist_definition

      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
