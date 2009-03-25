class AddMissingCopiedColumnsForGoalsAndObjectives < ActiveRecord::Migration
  def self.up
    add_column :goal_definitions, :copied_at, :datetime
    add_column :objective_definitions, :copied_at, :datetime
    
    add_column :goal_definitions, :copied_from, :integer
    add_column :objective_definitions, :copied_from, :integer
  end

  def self.down
    remove_column :objective_definitions, :copied_from
    remove_column :goal_definitions, :copied_from
    
    remove_column :objective_definitions, :copied_at
    remove_column :goal_definitions, :copied_at
  end
end
