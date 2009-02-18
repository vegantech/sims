class AddMarkedStateGoalsToDistrict < ActiveRecord::Migration
  def self.up
    add_column :districts, :marked_state_goal_ids, :string
  end

  def self.down
    remove_column :districts, :marked_state_goal_ids
  end
end
