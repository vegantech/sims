class CreateRights < ActiveRecord::Migration
  def self.up
    create_table :rights do |t|
      t.string :controller
      t.boolean :read
      t.boolean :write
      t.belongs_to :role

      t.timestamps
    end
  end

  def self.down
    drop_table :rights
  end
end
