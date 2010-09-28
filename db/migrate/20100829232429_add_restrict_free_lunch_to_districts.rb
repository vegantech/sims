class AddRestrictFreeLunchToDistricts < ActiveRecord::Migration
  def self.up
    add_column :districts, :restrict_free_lunch, :boolean, :default => true
  end

  def self.down
    remove_column :districts, :restrict_free_lunch
  end
end
