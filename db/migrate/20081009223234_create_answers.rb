class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.belongs_to :checklist
      t.belongs_to :answer_definition
      t.text :text

      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
