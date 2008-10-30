class CreateUserGroupAssignments < ActiveRecord::Migration
  def self.up
    create_table :user_group_assignments do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :is_principal, :default=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :user_group_assignments
  end
end
