class SwitchDistrictFieldsToSettings < ActiveRecord::Migration
  KEYS = [:key, :previous_key, :restrict_free_lunch, :forgot_password, :lock_tier]
  def self.up
    District.all.each do |d|
      KEYS.each do |k|
        val = (d.send :read_attribute,k)
        d.settings[k] = (val == 0) ? false : val
      end
      d.save!
    end
    remove_column :districts, :key
    remove_column :districts, :previous_key
    remove_column :districts, :restrict_free_lunch
    remove_column :districts, :forgot_password
    remove_column :districts, :marked_state_goal_ids
    remove_column :districts, :lock_tier
  end

  def self.down
    District.all.each do |d|
      KEYS.each do |k|
        d.send :write_attribute,k, d.settings[k]
      end
      d.save!
    end

    add_column :districts, :key, :string
    add_column :districts, :previous_key, :string
    add_column :districts, :restrict_free_lunch, :boolean, :null => false, :default => true
    add_column :districts, :forgot_password, :boolean, :null => false, :default => false
    add_column :districts, :marked_state_goal_ids, :string
    add_column :districts, :lock_tier, :boolean, :null => false, :default => false

  end
end
