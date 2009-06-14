class RenameDistrictNextKeyToPreviousKey < ActiveRecord::Migration
  def self.up
    rename_column :districts, :next_key, :previous_key
  end

  def self.down
    rename_column :districts, :previous_key, :next_key
  end
end
