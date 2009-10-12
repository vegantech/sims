class CreateExtSummaries < ActiveRecord::Migration
  def self.up
    create_table :ext_summaries do |t|
      t.belongs_to :student
      t.string :HomeLanguage
      t.string :streetAddress
      t.string :cityStateZip
      t.string :mealstatus
      t.string :englishProficiency
      t.string :specialEdStatus
      t.string :disability1
      t.string :disability2
      t.boolean :singleParent
      t.string :raceEthnicity
      t.integer :suspensions_in
      t.integer :suspensions_out
      t.integer :years_in_district
      t.integer :school_changes
      t.integer :years_at_current_school
      t.string :previous_school_name
      t.float :current_attendance_rate
      t.float :previous_attendance_rate
      t.boolean :esl
      t.integer :tardies

      t.timestamps
    end
  end

  def self.down
    drop_table :ext_summaries
  end
end
