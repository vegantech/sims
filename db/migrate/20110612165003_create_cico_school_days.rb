class CreateCicoSchoolDays < ActiveRecord::Migration
  def self.up
    create_table :cico_school_days do |t|
      t.references :cico_setting
      t.int :status
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :cico_school_days
  end
end
