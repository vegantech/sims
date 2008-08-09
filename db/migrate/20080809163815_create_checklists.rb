class CreateChecklists < ActiveRecord::Migration
  def self.up
    create_table :checklists do |t|
      t.integer :from_tier
      t.integer :student_id
      t.boolean :passed
      t.user :references
      t.school :references
      t.district :references

      t.timestamps
    end
  end

  def self.down
    drop_table :checklists
  end
end
