class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.references :district
      t.string :last_name
      t.string :first_name
      t.string :number
      t.integer :id_district
      t.integer :id_state
      t.integer :id_country

      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
