class RemoveRightsTable < ActiveRecord::Migration
  def self.up
    drop_table :rights
  end

  def self.down
    create_table :rights do |t|
      t.string :controller
      t.boolean :read
      t.boolean :write
      t.belongs_to :role

      t.timestamps
    end
  end
end
