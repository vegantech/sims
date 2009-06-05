class AddDistrictKeyNextKeyAndUserSalt < ActiveRecord::Migration
  def self.up
    add_column :districts, :key, :string, :default => ''
    add_column :districts, :next_key, :string, :default => ''
    add_column :users, :salt, :string, :default => ''
  end

  def self.down
    remove_column :users, :salt
    remove_column :districts, :next_key
    remove_column :districts, :key
  end
end
