class AddOtherAdvanceTierToMigrations < ActiveRecord::Migration
  def self.up
    add_column :recommendations, :advance_tier, :boolean, default: true
  end

  def self.down
    remove_column :recommendations, :advance_tier
  end
end
