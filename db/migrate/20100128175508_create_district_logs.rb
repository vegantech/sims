class CreateDistrictLogs < ActiveRecord::Migration
  def self.up
    create_table :district_logs do |t|
      t.belongs_to :district
      t.string :body
      t.timestamps
    end
    add_index :district_logs, [:district_id, :created_at]
  end

  def self.down
    remove_index :district_logs, :column => [:district_id, :created_at]
    drop_table :district_logs
  end
end
