class CreateUserSchoolAssignments < ActiveRecord::Migration
  def self.up
    create_table :user_school_assignments do |t|
      t.belongs_to :school
      t.belongs_to :user
      t.boolean :admin, default: false

      t.timestamps
    end
  end

  def self.down
    drop_table :user_school_assignments
  end
end
