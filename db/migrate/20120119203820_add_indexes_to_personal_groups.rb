class AddIndexesToPersonalGroups < ActiveRecord::Migration
  def self.up
    add_index :personal_groups, [:user_id, :school_id]
  end

  def self.down
    remove_index :personal_groups, :column => [:user_id, :school_id]
  end
end
