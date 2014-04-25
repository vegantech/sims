class AddRolesMaskToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :roles_mask, :integer, default: 0
    add_index :users, :roles_mask
  end

  def self.down
    remove_index :users, column: :roles_mask
    remove_column :users, :roles_mask
  end
end
