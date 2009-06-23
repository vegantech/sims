class RemoveIntegerFromSpecialUserGroups < ActiveRecord::Migration
  def self.up
    remove_column :special_user_groups, :integer
  end

  def self.down
    add_column :special_user_groups, :integer, :string
  end
end
