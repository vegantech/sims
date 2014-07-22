class CreateEnrollments < ActiveRecord::Migration
  def self.up
    create_table :enrollments do |t|
      t.references :school
      t.references :student
      t.string :grade, limit: 16

      t.timestamps
    end
  end

  def self.down
    drop_table :enrollments
  end
end
