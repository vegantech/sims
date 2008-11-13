class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.belongs_to :district
      t.belongs_to :state
      t.belongs_to :country
      t.boolean :system, :default => false
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
