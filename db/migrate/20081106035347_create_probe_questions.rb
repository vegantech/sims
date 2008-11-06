class CreateProbeQuestions < ActiveRecord::Migration
  def self.up
    create_table :probe_questions do |t|
      t.belongs_to :probe_definition
      t.integer :number
      t.string :operator
      t.integer :first_digit
      t.integer :second_digit

      t.timestamps
    end
  end

  def self.down
    drop_table :probe_questions
  end
end
