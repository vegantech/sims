class AddStatusToDistrictLogs < ActiveRecord::Migration
  def self.up
    add_column :district_logs, :status, :integer
    add_index  :district_logs, [:district_id, :status]
  end

  def self.down
    remove_index :district_logs, column: [:district_id, :status]
    remove_column :district_logs, :status
  end
end
