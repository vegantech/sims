class CreateExtSiblings < ActiveRecord::Migration
  def self.up
    create_table :ext_siblings do |t|
      t.belongs_to :student
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :student_number
      t.string :grade
      t.string :school_name
      t.integer :age

      t.timestamps
    end
  end

  def self.down
    drop_table :ext_siblings
  end
end
