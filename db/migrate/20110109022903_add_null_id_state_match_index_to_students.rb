class AddNullIdStateMatchIndexToStudents < ActiveRecord::Migration
  def self.up
   add_index :students, [:id_state, :district_id, :birthdate, :first_name, :last_name], name: :null_id_state_match
  end

  def self.down
   remove_index :students, name: :null_id_state_match
  end
end
