class ChangeStudentIdDistrictToString < ActiveRecord::Migration
  def self.up
    change_column :students,:district_student_id, :string
  end

  def self.down
    change_column :students,:district_student_id, :integer
  end
end
