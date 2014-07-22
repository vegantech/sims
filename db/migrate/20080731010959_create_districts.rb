class CreateDistricts < ActiveRecord::Migration
  def self.up
    create_table :districts do |t|
      t.string :name
      t.string :abbrev
      t.integer :state_dpi_num
      t.references :state

      t.timestamps
    end
  end

  def self.down
    drop_table :districts
  end
end
