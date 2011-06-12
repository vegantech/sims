class CreateCicoStudentDays < ActiveRecord::Migration
  def self.up
    create_table :cico_student_days do |t|
      t.references :cico_school_day
      t.references :intervention_probe_assignment
      t.integer :score
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :cico_student_days
  end
end
