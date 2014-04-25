class NoNilForRolesMask < ActiveRecord::Migration
  def self.up
    change_column :users, :roles_mask, :integer, null: false, default: 0
  end

  def self.down
    change_column :users, :roles_mask, :integer, null: true, default: 0
  end
end
