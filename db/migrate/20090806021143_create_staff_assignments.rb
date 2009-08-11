class CreateStaffAssignments < ActiveRecord::Migration
  def self.up
    create_table :staff_assignments do |t|
      t.belongs_to :school
      t.belongs_to :user
    end
  end

  def self.down
    drop_table :staff_assignments
  end
end
