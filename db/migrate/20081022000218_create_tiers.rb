class CreateTiers < ActiveRecord::Migration
  def self.up
    create_table :tiers do |t|
      t.belongs_to :district
      t.string :title
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :tiers
  end
end
