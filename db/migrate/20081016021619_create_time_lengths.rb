class CreateTimeLengths < ActiveRecord::Migration
  def self.up
    create_table :time_lengths do |t|
      t.string :title
      t.integer :days

      t.timestamps
    end
  end

  def self.down
    drop_table :time_lengths
  end
end
