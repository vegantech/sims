class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.string :name
      t.integer :id_district
      t.integer :id_state
      t.integer :id_country
      t.belongs_to :district

      t.timestamps
    end
  end

  def self.down
    drop_table :schools
  end
end
