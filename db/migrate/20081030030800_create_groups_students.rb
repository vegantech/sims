class CreateGroupsStudents < ActiveRecord::Migration
  def self.up
    create_table :groups_students, :id=>false do |t|
      t.column :student_id, :integer
      t.column :group_id, :integer
    end
  end

  def self.down
    drop_table :groups_students
  end
end
