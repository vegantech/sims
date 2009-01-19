class AddThresholdToFlagCategories < ActiveRecord::Migration
  def self.up
    add_column :flag_categories, :threshold, :integer, :default => 0
  end

  def self.down
    remove_column :flag_categories, :threshold
  end
end
