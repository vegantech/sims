class AddSuffixAndMiddleNameToUserAndStudent < ActiveRecord::Migration
  def self.up
    add_column :students, :middle_name, :string
    add_column :users, :middle_name, :string
    add_column :students, :suffix, :string
    add_column :users, :suffix, :string
  end

  def self.down
    remove_column :users, :suffix
    remove_column :students, :suffix
    remove_column :users, :middle_name
    remove_column :students, :middle_name
  end
end
