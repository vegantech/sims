class CreateHistoricalEnrollments < ActiveRecord::Migration
  def self.up
    create_table :historical_enrollments do |t|
      t.belongs_to :student
      t.belongs_to :district
      t.belongs_to :school
      t.date :start_date
      t.date :end_date
      t.integer :end_year

      t.timestamps
    end
  end

  def self.down
    drop_table :historical_enrollments
  end
end
