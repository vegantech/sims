class CreateCicoPeriodExpectations < ActiveRecord::Migration
  def self.up
    create_table :cico_period_expectations do |t|
      t.references :cico_student_day
      t.references :cico_period
      t.references :cico_expectation
      t.integer :score
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :cico_period_expectations
  end
end
