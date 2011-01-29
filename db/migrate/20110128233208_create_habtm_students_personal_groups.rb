class CreateHabtmStudentsPersonalGroups < ActiveRecord::Migration
  def self.up
    create_table :personal_groups_students, :id => false do |t|
      t.references :personal_group, :null => false
      t.references :student, :null => false
    end

    add_index(:personal_groups_students, [:personal_group_id, :student_id], :unique => true, :name=>:personal_groups_habtm_index)
  end

  def self.down
    remove_index(:personal_groups_students, :name => :personal_groups_habtm_index)

    drop_table :personal_groups_students
  end
end
