class AddLockTierToDistricts < ActiveRecord::Migration
  def self.up
    add_column :districts, :lock_tier, :boolean, default: false
  end

  def self.down
    remove_column :districts, :lock_tier
  end
end
