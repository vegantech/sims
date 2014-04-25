class AddForeignKeyIndicesToExtTables < ActiveRecord::Migration
  def self.up
    add_index :ext_test_scores, :student_id
    add_index :ext_arbitraries, :student_id
    add_index :ext_adult_contacts, :student_id
    add_index :ext_siblings, :student_id
    add_index :ext_summaries, :student_id
  end

  def self.down
    remove_index :ext_test_scores, column: :student_id
    remove_index :ext_summaries, column: :student_id
    remove_index :ext_siblings, column: :student_id
    remove_index :ext_adult_contacts, column: :student_id
    remove_index :ext_arbitraries, column: :student_id
  end
end
