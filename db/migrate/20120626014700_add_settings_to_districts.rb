class AddSettingsToDistricts < ActiveRecord::Migration
  def self.up
    add_column :districts, :settings, :text
  end

  def self.down
    remove_column :districts, :settings
  end
end
