class AddIndexToStudents < ActiveRecord::Migration
  def self.up
    add_index :students, :id_district
    add_index :students, :id_state
  end

  def self.down
    remove_index :students, column: :id_state
    remove_index :students, column: :id_district
  end
end
