class AddUserIdToDistrictLogs < ActiveRecord::Migration
  def self.up
    add_column :district_logs, :user_id, :integer
    add_index :district_logs, [:district_id,:user_id]
  end

  def self.down
    remove_index :district_logs, :column => [:district_id,:user_id]
    remove_column :district_logs, :user_id
  end
end
