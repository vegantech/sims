class <%= class_name %> < ActiveRecord::Migration
  def self.up
      create_table :railmail_deliveries do |t|
        t.column "recipients", :string, :limit => 1.kilobyte
        t.column "from", :string, :limit => 255
        t.column "subject", :string, :limit => 1.kilobyte
        t.column "sent_at", :datetime
        t.column "read_at", :datetime
        t.column "raw", :string, :limit => 10.megabytes
      end
  end

  def self.down
    drop_table :railmail_deliveries
  end
end
