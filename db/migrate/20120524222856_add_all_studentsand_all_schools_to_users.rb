class AddAllStudentsandAllSchoolsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :all_students, :boolean, null: false, default: false
    add_column :users, :all_schools, :boolean, null: false, default: false
  end

  def self.down
    remove_column :users, :all_schools
    remove_column :users, :all_students
  end
end
